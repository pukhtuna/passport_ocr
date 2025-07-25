import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passport_ocr/views/documents_screen.dart';

void main() {
  runApp(const PassportScannerApp());
}

class PassportScannerApp extends StatelessWidget {
  const PassportScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pak Passport OCR',
      theme: ThemeData(useMaterial3: true),
      home: const DocumentsScreen(),
    );
  }
}
