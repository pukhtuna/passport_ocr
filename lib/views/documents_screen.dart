import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:passport_ocr/views/mrz_scan_screen.dart';
import 'package:passport_ocr/widgets/document_tile.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  File? _scannedImage;
  Map<String, String>? _parsedMRZ;
  bool _isProcessing = false;

  final documents = [
    {'title': 'Passport Photo', 'status': 'done'},
    {'title': 'Passport', 'status': 'expiring'},
    {'title': 'Visa', 'status': 'required'},
    {'title': 'Labor Card', 'status': 'required'},
    {'title': 'Emirates ID Application Form', 'status': 'none'},
    {'title': 'Emirates ID Card', 'status': 'done'},
    {'title': 'Insurance Card', 'status': 'none'},
    {'title': 'Educational Certificate', 'status': 'none'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B123C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Documents', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: documents.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final doc = documents[index];
              return DocumentTile(
                title: doc['title']!,
                status: doc['status']!,
                onTap:
                    doc['title'] == 'Passport' ? _showImageSourceSheet : null,
              );
            },
          ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.orangeAccent),
              ),
            ),
        ],
      ),
    );
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _getImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _getImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      setState(() {
        _scannedImage = File(picked.path);
        _parsedMRZ = null;
        _isProcessing = true;
      });

      final text = await _extractTextFromImage(_scannedImage!);
      final mrz = _parseMRZ(text);
      debugPrint('MRZ Parsed: $mrz');

      setState(() {
        _parsedMRZ = mrz;
        _isProcessing = false;
      });

      Get.to(() => PassportScannerScreen(
            mrzResult: _parsedMRZ,
          ));
    }
  }

  Future<String> _extractTextFromImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final text = await recognizer.processImage(inputImage);
    await recognizer.close();
    return text.text;
  }

  Map<String, String> _parseMRZ(String fullText) {
    final lines = fullText.split('\n').map((e) => e.trim()).toList();
    final mrzLines = lines
        .map((line) => line.replaceAll('«', '<').replaceAll(' ', ''))
        .where((line) =>
            line.length >= 40 && RegExp(r'^[A-Z0-9<]+$').hasMatch(line))
        .toList();

    if (mrzLines.length < 2) return {};

    final line1 = mrzLines[mrzLines.length - 2].padRight(44, '<');
    final line2 = mrzLines[mrzLines.length - 1].padRight(44, '<');

    final passportType = line1.substring(0, 1);
    final issuingCountry = line1.substring(2, 5);
    final names = line1.substring(5).split('<<');
    final lastName = names[0].replaceAll('<', ' ');
    final firstName = names.length > 1 ? names[1].replaceAll('<', ' ') : '';

    final passportNumber =
        line2.substring(0, 9).replaceAll(RegExp(r'[^A-Z0-9]'), '');
    final nationality = line2.substring(10, 13);
    final birthDate = line2.substring(13, 19); // YYMMDD
    final sex = line2.substring(20, 21);
    final expiryDate = line2.substring(21, 27); // YYMMDD

    return {
      'Passport Type': passportType,
      'Issuing Country': issuingCountry,
      'Last Name': lastName,
      'First Name': firstName,
      'Passport Number': passportNumber,
      'Nationality': nationality,
      'Date of Birth': _formatDate(birthDate),
      'Sex': sex,
      'Expiry Date': _formatDate(expiryDate),
    };
  }

  String _formatDate(String yymmdd) {
    if (yymmdd.length != 6 || int.tryParse(yymmdd) == null) return yymmdd;
    final year = int.parse(yymmdd.substring(0, 2));
    final month = yymmdd.substring(2, 4);
    final day = yymmdd.substring(4, 6);
    final fullYear = year > 50 ? '19$year' : '20$year';
    return '$day-$month-$fullYear';
  }
}
