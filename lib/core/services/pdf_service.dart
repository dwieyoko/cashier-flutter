import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../data/models/order.dart';
import '../../data/models/store_config.dart';
import '../utils/formatters.dart';

class PdfService {
  /// Generate a receipt PDF for an order
  static Future<Uint8List> generateReceipt(Order order, StoreConfig config) async {
    final pdf = pw.Document();
    
    // Receipt Theme
    final theme = pw.ThemeData.withFont(
      base: await PdfGoogleFonts.interRegular(),
      bold: await PdfGoogleFonts.interBold(),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80, // Thermal printer width (80mm)
        theme: theme,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Store Header
              pw.Text(
                config.storeName,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              if (config.address != null)
                pw.Text(
                  config.address!,
                  style: const pw.TextStyle(fontSize: 10),
                  textAlign: pw.TextAlign.center,
                ),
              if (config.phone != null)
                pw.Text(
                  config.phone!,
                  style: const pw.TextStyle(fontSize: 10),
                ),
              
              pw.SizedBox(height: 10),
              pw.Divider(thickness: 0.5),
              pw.SizedBox(height: 5),
              
              // Order Info
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Order: ${AppFormatters.formatOrderId(order.id)}', style: const pw.TextStyle(fontSize: 10)),
                  pw.Text(AppFormatters.formatDateTime(order.createdAt), style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
              
              pw.SizedBox(height: 10),
              
              // Items Header
              pw.Row(
                children: [
                  pw.Expanded(flex: 3, child: pw.Text('Item', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))),
                  pw.Expanded(flex: 1, child: pw.Text('Qty', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
                  pw.Expanded(flex: 2, child: pw.Text('Total', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Divider(thickness: 0.5, borderStyle: pw.BorderStyle.dashed),
              pw.SizedBox(height: 5),
              
              // Items List
              ...order.items.map((item) => pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 2),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 3, 
                      child: pw.Text(
                        item.productName, 
                        style: const pw.TextStyle(fontSize: 10),
                        maxLines: 2,
                      ),
                    ),
                    pw.Expanded(
                      flex: 1, 
                      child: pw.Text(
                        'x${item.quantity}', 
                        style: const pw.TextStyle(fontSize: 10),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Expanded(
                      flex: 2, 
                      child: pw.Text(
                        _formatCurrency(item.subtotal, config), 
                        style: const pw.TextStyle(fontSize: 10),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
              )),
              
              pw.SizedBox(height: 10),
              pw.Divider(thickness: 0.5),
              pw.SizedBox(height: 5),
              
              // Totals
              _buildSummaryRow('Subtotal', _formatCurrency(order.total - order.tax, config)),
              _buildSummaryRow('Tax', _formatCurrency(order.tax, config)),
              pw.SizedBox(height: 5),
              _buildSummaryRow(
                'TOTAL', 
                _formatCurrency(order.total, config), 
                isBold: true, 
                fontSize: 14,
              ),
              
              pw.SizedBox(height: 5),
              pw.Divider(thickness: 0.5),
              pw.SizedBox(height: 10),
              
              // Footer
              pw.Text(
                'Payment: ${order.paymentMethod}',
                style: const pw.TextStyle(fontSize: 10),
              ),
              if (config.receiptFooter != null)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 10),
                  child: pw.Text(
                    config.receiptFooter!,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontStyle: pw.FontStyle.italic,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                
              pw.SizedBox(height: 20),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
  
  static pw.Widget _buildSummaryRow(String label, String value, {bool isBold = false, double fontSize = 10}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ],
    );
  }
  
  static String _formatCurrency(double amount, StoreConfig config) {
    return AppFormatters.formatCurrency(
      amount, 
      symbol: config.currencySymbol, 
      code: config.currencyCode,
    );
  }
}
