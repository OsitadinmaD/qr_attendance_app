
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerPage extends StatelessWidget {

  const QrScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    //final AttendanceController controller = Get.put(TakeAttendanceController());
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Scan QR Code', style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500, color: Colors.white)),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, size: 25, color: Colors.white,),
          onPressed: () => Get.back(),
        ),
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionTimeoutMs: 1000, // Optional: Timeout to prevent continuous detection
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
            final String qrCodeData = barcodes.first.rawValue!;
            // Vibrate or play a sound here for feedback if desired
            // Important: Pop the screen and pass data back
            Get.back(result: qrCodeData); // Using Get.back() for simplicity
          }
        },
      ),
    );
  }
}