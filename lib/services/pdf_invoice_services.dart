// lib/services/pdf_invoice_service.dart

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

/// Service class responsible for generating and managing PDF invoices
class PdfInvoiceService {
  /// Generates and downloads an invoice PDF with the provided details
  ///
  /// Parameters:
  /// - [dueDate]: The due date for the invoice
  /// - [fullname]: Customer's full name
  /// - [roomId]: Room identifier
  /// - [energy]: Energy consumption value
  /// - [context]: BuildContext for navigation and showing dialogs
  ///
  /// Throws an exception if PDF generation or file operations fail
  static Future<void> generateAndDownloadInvoice({
    required String dueDate,
    required String fullname,
    required String roomId,
    required double energy,
    required BuildContext context,
  }) async {
    try {
      final pdf = pw.Document();

      // Load fonts
      final fontData = await rootBundle.load("fonts/Poppins-Regular.ttf");
      final semiBoldFontData =
          await rootBundle.load("fonts/Poppins-SemiBold.ttf");
      final ttf = pw.Font.ttf(fontData.buffer.asByteData());
      final semiBoldTtf = pw.Font.ttf(semiBoldFontData.buffer.asByteData());

      // Load logo
      final img = await rootBundle.load('assets/images/mini-logo.png');
      final imageBytes = img.buffer.asUint8List();
      pw.Image image1 = pw.Image(pw.MemoryImage(imageBytes));

      pdf.addPage(await _buildPdfPage(
        ttf: ttf,
        semiBoldTtf: semiBoldTtf,
        image1: image1,
        dueDate: dueDate,
        fullname: fullname,
        roomId: roomId,
        energy: energy,
      ));

      // Save and share PDF
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'Invoice_${fullname.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles(
        [XFile(filePath)],
        subject: 'Invoice Listrik - $fullname',
      );

      Navigator.pushReplacementNamed(context, '/admin/dashboard');
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Gagal mengunduh invoice: ${e.toString()}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  /// Builds a PDF page with the invoice content
  static Future<pw.Page> _buildPdfPage({
    required pw.Font ttf,
    required pw.Font semiBoldTtf,
    required pw.Image image1,
    required String dueDate,
    required String fullname,
    required String roomId,
    required double energy,
  }) async {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(0),
      theme: pw.ThemeData.withFont(
        base: ttf,
        bold: semiBoldTtf,
      ),
      build: (context) => pw.Container(
        width: PdfPageFormat.a4.width,
        child: _buildPdfContent(
          image1: image1,
          dueDate: dueDate,
          fullname: fullname,
          roomId: roomId,
          energy: energy,
        ),
      ),
    );
  }

  /// Builds the main content of the PDF
  static pw.Widget _buildPdfContent({
    required pw.Image image1,
    required String dueDate,
    required String fullname,
    required String roomId,
    required double energy,
  }) {
    return pw.Stack(
      children: [
        _buildHeader(),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 20.0),
          child: pw.Column(
            children: [
              pw.SizedBox(height: 130),
              _buildInvoiceContainer(
                image1: image1,
                dueDate: dueDate,
                fullname: fullname,
                roomId: roomId,
                energy: energy,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the header section of the PDF
  static pw.Widget _buildHeader() {
    return pw.Container(
      width: PdfPageFormat.a4.width,
      height: 180,
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex("#2F3B41"),
        borderRadius: const pw.BorderRadius.only(
          bottomLeft: pw.Radius.circular(28.0),
          bottomRight: pw.Radius.circular(28.0),
        ),
      ),
    );
  }

  /// Builds a row in the PDF with a label and value
  static pw.Widget buildPdfRow(
    String label,
    String value, {
    double labelSize = 13,
    double valueSize = 13,
    PdfColor labelColor = const PdfColor(0.42, 0.42, 0.42),
    PdfColor valueColor = PdfColors.black,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            flex: 1,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: labelSize,
                color: labelColor,
              ),
            ),
          ),
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: valueSize,
                color: valueColor,
                fontWeight: pw.FontWeight.bold,
              ),
              textAlign: pw.TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a dotted border separator
  static pw.Widget buildPdfDottedBorder() {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 8.0),
      child: pw.Row(
        children: List.generate(
          150 ~/ 3,
          (index) => pw.Expanded(
            child: pw.Container(
              color: index % 4 == 0
                  ? PdfColor.fromHex('#0000004D')
                  : PdfColor.fromHex('#00000000'),
              height: 1,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the main invoice container with all details
  static pw.Widget _buildInvoiceContainer({
    required pw.Image image1,
    required String dueDate,
    required String fullname,
    required String roomId,
    required double energy,
  }) {
    return pw.Container(
      width: PdfPageFormat.a4.width,
      padding: const pw.EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 25.0,
      ),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          color: PdfColor.fromHex("#00A6FF"),
          width: 1.0,
        ),
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(28.0),
      ),
      child: pw.Column(
        children: [
          pw.Column(
            children: [
              image1,
              pw.Text(
                'Tagihan Listrik',
                style: pw.TextStyle(
                  fontSize: 20.0,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.black,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 30.0),
          pw.Column(
            children: [
              buildPdfRow('Tanggal',
                  '${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())} WIB'),
              buildPdfDottedBorder(),
              buildPdfRow('Jatuh Tempo', dueDate),
              buildPdfRow('Nama', fullname),
              buildPdfRow('No Kamar', roomId),
              buildPdfRow('Energi Total', energy.toStringAsFixed(0)),
              buildPdfRow('/kWh', 'Rp 1.400,00'),
              buildPdfDottedBorder(),
              buildPdfRow(
                'Total Bayar',
                NumberFormat.currency(
                  locale: 'id',
                  symbol: 'Rp ',
                  decimalDigits: 0,
                ).format(1400 * energy),
                labelSize: 13,
                valueSize: 20,
                labelColor: PdfColors.black,
                valueColor: PdfColor.fromHex("#00A6FF"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
