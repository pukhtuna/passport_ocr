import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passport_ocr/widgets/helpers.dart';

class PassportScannerScreen extends StatelessWidget {
  final Map<String, String>? mrzResult;

  const PassportScannerScreen({super.key, required this.mrzResult});

  @override
  Widget build(BuildContext context) {
    final data = mrzResult ?? {};
    final hasData = data.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B123C),
        elevation: 0,
        title: const Text('Passport', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: Get.size.height,
              width: Get.size.width,
              child: Image.asset(
                'assets/images/bg.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SCANNED FILE',
                    style: TextStyle(
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A1D52),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'UPLOADED_DOC.PDF\n124 Bytes, adobe acrobat pdf',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Icon(Icons.check_circle, color: Colors.greenAccent),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A1D52),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: hasData
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ListView(
                                    children: [
                                      buildRow(
                                          'First Name', data['First Name']),
                                      buildRow('Last Name', data['Last Name']),
                                      buildRow('Passport No.',
                                          data['Passport Number']),
                                      buildRow('Passport Country',
                                          data['Nationality']),
                                      buildRow('Place of Issue',
                                          data['Place of Issue']),
                                      buildRow('Passport Issue Date',
                                          data['Passport Issue Date']),
                                      buildRow('Passport Expiry Date',
                                          data['Expiry Date']),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Center(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      // handle edit action
                                    },
                                    icon: const Icon(Icons.edit,
                                        color: Colors.white),
                                    label: const Text('EDIT DETAILS',
                                        style: TextStyle(color: Colors.white)),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Colors.transparent),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : const Center(
                              child: Text(
                                'No MRZ data found.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
