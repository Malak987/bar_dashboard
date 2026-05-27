import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../../core/constants/shop_info.dart';
import '../../../../core/utils/gps_helper.dart';
import '../../domain/entities/order_entity.dart';
import 'invoice_cache.dart';

/// 🧾 Invoice Generator - يولّد PDF للفاتورة الحرارية 80mm
class InvoiceGenerator {
  static Future<Uint8List> generatePdf(
      OrderEntity order, {
        int dailyNumber = 0,
      }) async {
    final pdf = pw.Document();

    // 🚀 استخدام الـ Cache
    final fonts = await InvoiceCache.getFonts();
    final logoBytes = await InvoiceCache.getLogoBytes();
    final logoImage = pw.MemoryImage(logoBytes);

    // 🆕 إعداد قائمة الـ fallback fonts
    // - الأساسي: Cairo (للنص العربي والإنجليزي)
    // - Fallback: Noto Emoji (للـ emojis لو متاح)
    final fontFallback = <pw.Font>[
      if (fonts.emoji != null) fonts.emoji!,
    ];

    final branch = ShopInfo.branchFromOrder(
      branchId: order.branchId,
      branchName: order.branchName,
    );

    final gps = GpsHelper.extractFromAddress(order.address);
    final cleanAddress = GpsHelper.cleanAddress(order.address);
    final gpsUrl = gps?.googleMapsUrl ?? '';

    const pageWidth = 80.0 * PdfPageFormat.mm;
    const pageHeight = double.infinity;

    pdf.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(pageWidth, pageHeight,
            marginAll: 6 * PdfPageFormat.mm),
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(
          base: fonts.regular,
          bold: fonts.bold,
          fontFallback: fontFallback, // 🆕 fallback للـ emojis
        ),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // ═════ Header مع اللوجو ═════
              pw.Center(
                child: pw.Container(
                  width: 60,
                  height: 60,
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    image: pw.DecorationImage(image: logoImage),
                  ),
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Center(
                child: pw.Text(
                  ShopInfo.brandNameAr,
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  '${ShopInfo.brandNameEn} - ${ShopInfo.brandTagline}',
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Center(
                child: pw.Text(
                  branch.nameAr,
                  style: pw.TextStyle(
                      fontSize: 11, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  branch.addressAr,
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 8),
                ),
              ),
              pw.SizedBox(height: 4),
              // 🎯 استخدام Tel: بدل اموجي
              pw.Center(
                child: pw.Text(
                  'Tel: ${branch.phonesDisplay}',
                  style: const pw.TextStyle(fontSize: 9),
                  textDirection: pw.TextDirection.ltr,
                ),
              ),

              _divider(),

              // ═════ معلومات الفاتورة ═════
              // 🔢 رقم الطلب اليومي - بارز
              if (dailyNumber > 0) ...[
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                      vertical: 6, horizontal: 8),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Row(
                    mainAxisAlignment:
                    pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('طلب اليوم رقم:',
                          style: const pw.TextStyle(fontSize: 10)),
                      pw.Text(
                        '#${dailyNumber.toString().padLeft(3, '0')}',
                        style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 4),
              ],
              _infoRow('رقم الفاتورة',
                  '#${order.id.substring(0, 8).toUpperCase()}'),
              _infoRow(
                  'التاريخ',
                  DateFormat('yyyy/MM/dd – HH:mm')
                      .format(order.createdDateTime)),
              _infoRow('الحالة', order.statusName),
              if (order.couponCode != null && order.couponCode!.isNotEmpty)
                _infoRow('كود الخصم', order.couponCode!),

              _divider(),

              // ═════ بيانات العميل ═════
              pw.Text('بيانات العميل:',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 10)),
              pw.SizedBox(height: 2),
              _infoRow('الاسم', order.userName),
              pw.SizedBox(height: 4),
              pw.Text('العنوان:',
                  style: const pw.TextStyle(fontSize: 9)),
              pw.Text(cleanAddress,
                  style: const pw.TextStyle(fontSize: 8)),

              _divider(),

              // ═════ الأصناف ═════
              pw.Text('الأصناف:',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 10)),
              pw.SizedBox(height: 4),

              pw.Container(
                color: PdfColors.grey200,
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 4, vertical: 3),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 4,
                      child: pw.Text('الصنف',
                          style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text('عدد',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text('السعر',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),
              ),

              ...order.orderItems.map((item) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 4, vertical: 4),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 4,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                                item.productNameAr ?? 'منتج محذوف',
                                style: const pw.TextStyle(fontSize: 9)),
                            if (item.sizeName != null)
                              pw.Text('- حجم: ${item.sizeName}',
                                  style: const pw.TextStyle(
                                      fontSize: 7,
                                      color: PdfColors.grey700)),
                            if (item.flavors.isNotEmpty)
                              pw.Text(
                                  '- نكهات: ${item.flavors.map((f) => f.flavorNameAr ?? '').join('، ')}',
                                  style: const pw.TextStyle(
                                      fontSize: 7,
                                      color: PdfColors.grey700)),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text('${item.quantity}',
                            textAlign: pw.TextAlign.center,
                            style: const pw.TextStyle(fontSize: 9)),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                            '${item.totalPrice.toStringAsFixed(0)}',
                            textAlign: pw.TextAlign.center,
                            style: const pw.TextStyle(fontSize: 9)),
                      ),
                    ],
                  ),
                );
              }),

              _divider(),

              // ═════ الإجماليات ═════
              _totalRow(
                  'المجموع', 'L.E ${order.subtotal.toStringAsFixed(2)}'),
              _totalRow('رسوم التوصيل',
                  'L.E ${order.deliveryFee.toStringAsFixed(2)}'),
              if (order.discountAmount > 0)
                _totalRow('الخصم',
                    '- L.E ${order.discountAmount.toStringAsFixed(2)}',
                    color: PdfColors.green),

              pw.SizedBox(height: 4),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                    vertical: 6, horizontal: 4),
                decoration: pw.BoxDecoration(
                  color: PdfColors.black,
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('الإجمالي',
                        style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                        'L.E ${order.totalAmount.toStringAsFixed(2)}',
                        style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ),

              if (order.note != null && order.note!.isNotEmpty) ...[
                _divider(),
                pw.Text('ملاحظات:',
                    style: pw.TextStyle(
                        fontSize: 9, fontWeight: pw.FontWeight.bold)),
                pw.Text(order.note!,
                    style: const pw.TextStyle(fontSize: 8)),
              ],

              _divider(),

              // ═════ QR Code للموقع ═════
              if (gps != null) ...[
                // 🎯 بدل اموجي 📍 نستخدم نص + رمز Unicode بسيط
                pw.Center(
                  child: pw.Text('* موقع التوصيل *',
                      style: pw.TextStyle(
                          fontSize: 9, fontWeight: pw.FontWeight.bold)),
                ),
                pw.SizedBox(height: 4),
                pw.Center(
                  child: pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: gpsUrl,
                    width: 80,
                    height: 80,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Center(
                  child: pw.Text(
                    'امسح الكود لفتح الموقع',
                    style: const pw.TextStyle(
                        fontSize: 7, color: PdfColors.grey600),
                  ),
                ),
                pw.Center(
                  child: pw.Text(
                    gps.displayShort,
                    style: const pw.TextStyle(
                        fontSize: 7, color: PdfColors.grey600),
                    textDirection: pw.TextDirection.ltr,
                  ),
                ),
                _divider(),
              ],

              // ═════ Footer ═════
              // 🎯 بدل القلب اموجي ❤️ نستخدم رمز Unicode (♥)
              pw.Center(
                child: pw.Text(
                  ShopInfo.brandSlogan,
                  style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Center(
                child: pw.Text(
                  'Follow us: ${branch.socialMedia}',
                  style: const pw.TextStyle(fontSize: 7),
                  textDirection: pw.TextDirection.ltr,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Center(
                child: pw.Text(
                  'شكراً لاختياركم بار',
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _divider() => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 4),
    child: pw.Container(
        height: 0.5,
        color: PdfColors.grey400,
        child: pw.Container()),
  );

  static pw.Widget _infoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('$label:',
              style: const pw.TextStyle(
                  fontSize: 9, color: PdfColors.grey800)),
          pw.Flexible(
            child: pw.Text(value,
                textAlign: pw.TextAlign.left,
                style: pw.TextStyle(
                    fontSize: 9, fontWeight: pw.FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  static pw.Widget _totalRow(String label, String value,
      {PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
          pw.Text(value,
              style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: color)),
        ],
      ),
    );
  }
}
