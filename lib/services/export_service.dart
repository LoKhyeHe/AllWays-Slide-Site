import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ExportService {
  /// Captures a widget via its RepaintBoundary key and returns raw PNG bytes.
  static Future<Uint8List?> captureSlide(GlobalKey key) async {
    try {
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  /// Builds a PDF from a list of PNG slide images and triggers the print/save dialog.
  static Future<void> exportToPdf(List<Uint8List> slideImages) async {
    final pdf = pw.Document();

    for (final imgBytes in slideImages) {
      final pdfImage = pw.MemoryImage(imgBytes);
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat(
            297 * PdfPageFormat.mm,
            167 * PdfPageFormat.mm, // 16:9 widescreen
          ),
          margin: pw.EdgeInsets.zero,
          build: (ctx) => pw.Image(pdfImage, fit: pw.BoxFit.contain),
        ),
      );
    }

    await Printing.layoutPdf(
      onLayout: (_) async => pdf.save(),
      name: 'pitch_deck.pdf',
    );
  }
}
