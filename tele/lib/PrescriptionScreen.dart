import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrescriptionScreen extends StatelessWidget {
  final pw.Document pdf = pw.Document();

  PrescriptionScreen({super.key});

  Future<Uint8List> generatePdf(PdfPageFormat format) async {
    final logo = await imageFromAssetBundle('assets/images/app_icon.jpg'); // Add logo in assets
    final signature = await imageFromAssetBundle('assets/images/noads.png'); // Add signature in assets

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    // pw.Image(logo),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text("Dr. Sarah Lee, MBBS, MD", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                        pw.Text("Reg No: KMPDC/123456"),
                        pw.Text("Nairobi Health Clinic"),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text("Patient: John Doe"),
                pw.Text("Age: 29    Gender: Male"),
                pw.Text("Date: 25 April 2025"),
                pw.Divider(thickness: 2),
                pw.Text("Diagnosis: Common Cold", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Bullet(text: "Paracetamol 500mg – 1 tablet after meals (3x/day) for 5 days"),
                pw.Bullet(text: "Cetirizine 10mg – 1 tablet at night for 3 days"),
                pw.SizedBox(height: 10),
                pw.Text("Advice: Drink plenty of fluids, take rest", style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
                pw.Spacer(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        // pw.Image(signature),
                        pw.Text("Signed: Dr. Sarah Lee"),
                        pw.Text("Prescription ID: RX20250425-001"),
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Prescription")),
      body: Center(
        child: ElevatedButton(
          child: Text("Generate & Share PDF"),
          onPressed: () {
            Printing.layoutPdf(
              onLayout: (format) => generatePdf(format),
            );
          },
        ),
      ),
    );
  }
}
