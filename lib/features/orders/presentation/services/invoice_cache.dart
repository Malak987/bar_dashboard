import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../domain/entities/order_entity.dart';
import 'invoice_generator.dart';

/// 🚀 Cache للـ PDFs والـ Fonts عشان السرعة
class InvoiceCache {
  // ═══════════════ Cache للخطوط ═══════════════
  static pw.Font? _cachedFont;
  static pw.Font? _cachedFontBold;
  static pw.Font? _cachedEmojiFont; // 🆕 خط الـ emojis
  static Uint8List? _cachedLogoBytes;

  /// تحميل الخطوط مرة واحدة
  /// 🆕 بيرجع الـ emoji font أيضاً كـ fallback
  static Future<
      ({
      pw.Font regular,
      pw.Font bold,
      pw.Font? emoji,
      })> getFonts() async {
    if (_cachedFont != null && _cachedFontBold != null) {
      return (
      regular: _cachedFont!,
      bold: _cachedFontBold!,
      emoji: _cachedEmojiFont,
      );
    }

    pw.Font ttf;
    pw.Font ttfBold;
    try {
      final fontData =
      await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
      final boldFontData =
      await rootBundle.load('assets/fonts/Cairo-Bold.ttf');
      ttf = pw.Font.ttf(fontData);
      ttfBold = pw.Font.ttf(boldFontData);
    } catch (_) {
      ttf = await PdfGoogleFonts.cairoRegular();
      ttfBold = await PdfGoogleFonts.cairoBold();
    }

    // 🆕 تحميل خط الـ Emojis (لو فشل، نخلي القيمة null)
    pw.Font? emojiFont;
    try {
      // محاولة من assets أولاً
      final emojiData =
      await rootBundle.load('assets/fonts/NotoColorEmoji.ttf');
      emojiFont = pw.Font.ttf(emojiData);
    } catch (_) {
      // Fallback لـ Google Fonts
      try {
        emojiFont = await PdfGoogleFonts.notoColorEmoji();
      } catch (_) {
        // مش متاح، هنستخدم نصوص بدل الـ emojis
        emojiFont = null;
      }
    }

    _cachedFont = ttf;
    _cachedFontBold = ttfBold;
    _cachedEmojiFont = emojiFont;
    return (regular: ttf, bold: ttfBold, emoji: emojiFont);
  }

  static Future<Uint8List> getLogoBytes() async {
    if (_cachedLogoBytes != null) return _cachedLogoBytes!;
    final bytes = (await rootBundle.load('assets/images/bar_logo.png'))
        .buffer
        .asUint8List();
    _cachedLogoBytes = bytes;
    return bytes;
  }

  // ═══════════════ Cache للـ PDFs ═══════════════
  static final Map<String, _CachedPdf> _pdfCache = {};
  static const Duration _cacheLifetime = Duration(minutes: 5);

  static Future<Uint8List> getOrGeneratePdf(
      OrderEntity order, {
        int dailyNumber = 0,
      }) async {
    final cached = _pdfCache[order.id];
    if (cached != null && !cached.isExpired) {
      if (cached.statusHash == _orderHash(order)) {
        return cached.bytes;
      }
    }

    final bytes = await InvoiceGenerator.generatePdf(order, dailyNumber: dailyNumber);
    _pdfCache[order.id] = _CachedPdf(
      bytes: bytes,
      timestamp: DateTime.now(),
      statusHash: _orderHash(order),
    );

    _cleanupExpired();
    return bytes;
  }

  static Future<Uint8List> regenerate(
      OrderEntity order, {
        int dailyNumber = 0,
      }) async {
    _pdfCache.remove(order.id);
    return getOrGeneratePdf(order, dailyNumber: dailyNumber);
  }

  static void _cleanupExpired() {
    _pdfCache.removeWhere((_, v) => v.isExpired);
  }

  static String _orderHash(OrderEntity o) =>
      '${o.status}_${o.totalAmount}_${o.orderItems.length}';

  static void clearAll() {
    _pdfCache.clear();
  }
}

class _CachedPdf {
  final Uint8List bytes;
  final DateTime timestamp;
  final String statusHash;

  _CachedPdf({
    required this.bytes,
    required this.timestamp,
    required this.statusHash,
  });

  bool get isExpired =>
      DateTime.now().difference(timestamp) > InvoiceCache._cacheLifetime;
}
