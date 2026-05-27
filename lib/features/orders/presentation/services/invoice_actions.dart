import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/order_entity.dart';
import 'invoice_cache.dart';

/// 🎯 خدمات الفاتورة: طباعة، حفظ، مشاركة، معاينة
class InvoiceActions {
  /// 🖨️ طباعة مباشرة - بدون loading dialog إضافي
  /// Print Dialog بيظهر فوراً، والـ PDF يتولد في الخلفية
  static Future<void> printInvoice(
      BuildContext context, OrderEntity order, {
        int dailyNumber = 0,
      }) async {
    try {
      // ⚡ بنبعت الـ callback مباشرة بدون أي loading dialog
      // الـ Printing هيظهر dialog الطباعة فوراً، و الـ PDF يتولّد جنب
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async {
          return await InvoiceCache.getOrGeneratePdf(order, dailyNumber: dailyNumber);
        },
        name: 'invoice_${order.id.substring(0, 8)}',
        format: const PdfPageFormat(80 * PdfPageFormat.mm, double.infinity),
      );
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'فشل الطباعة: $e');
      }
    }
  }

  /// 👁️ معاينة الفاتورة في صفحة كاملة
  static Future<void> previewInvoice(
      BuildContext context, OrderEntity order, {
        int dailyNumber = 0,
      }) async {
    // ✅ نفتح الصفحة مباشرة - الـ PdfPreview بيتعامل مع الـ loading
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(
                'فاتورة #${order.id.substring(0, 8).toUpperCase()}'),
            backgroundColor: AppColors.surface,
            actions: [
              IconButton(
                icon: const Icon(Icons.print),
                tooltip: 'طباعة',
                onPressed: () => Printing.layoutPdf(
                  onLayout: (format) async =>
                      InvoiceCache.getOrGeneratePdf(order, dailyNumber: dailyNumber),
                  name: 'invoice_${order.id.substring(0, 8)}',
                  format: const PdfPageFormat(
                      80 * PdfPageFormat.mm, double.infinity),
                ),
              ),
            ],
          ),
          body: PdfPreview(
            // ⚡ بنحمل الـ PDF بشكل غير متزامن مباشرة من الـ cache
            build: (format) async =>
                InvoiceCache.getOrGeneratePdf(order, dailyNumber: dailyNumber),
            allowPrinting: true,
            allowSharing: true,
            canChangePageFormat: false,
            canChangeOrientation: false,
            canDebug: false,
            pdfFileName: 'invoice_${order.id.substring(0, 8)}.pdf',
            previewPageMargin: const EdgeInsets.all(8),
            pageFormats: const {
              'إيصال 80mm':
              PdfPageFormat(80 * PdfPageFormat.mm, double.infinity),
            },
            initialPageFormat: const PdfPageFormat(
                80 * PdfPageFormat.mm, double.infinity),
          ),
        ),
      ),
    );
  }

  /// 💾 حفظ الفاتورة كـ PDF
  static Future<void> savePdf(
      BuildContext context, OrderEntity order, {
        int dailyNumber = 0,
      }) async {
    try {
      final pdfData = await InvoiceCache.getOrGeneratePdf(order, dailyNumber: dailyNumber);
      await Printing.sharePdf(
        bytes: pdfData,
        filename: 'invoice_${order.id.substring(0, 8)}.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'فشل الحفظ: $e');
      }
    }
  }

  /// 📤 مشاركة الفاتورة
  static Future<void> shareInvoice(
      BuildContext context, OrderEntity order, {
        int dailyNumber = 0,
      }) async {
    try {
      final pdfData = await InvoiceCache.getOrGeneratePdf(order, dailyNumber: dailyNumber);

      final xfile = XFile.fromData(
        pdfData,
        mimeType: 'application/pdf',
        name: 'invoice_${order.id.substring(0, 8)}.pdf',
      );
      Share.shareXFiles(
        [xfile],
        text: 'فاتورة طلب #${order.id.substring(0, 8).toUpperCase()}\n'
            'الإجمالي: L.E ${order.totalAmount.toStringAsFixed(2)}',
        subject: 'فاتورة من بار للحلويات',
      );
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'فشل المشاركة: $e');
      }
    }
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }
}
