import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/student_screen/pages/qr_scan_screen.dart/controller/qr_scanner_controller.dart';


class QrScanScreen extends StatelessWidget {
  const QrScanScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final QRScannerController scannerController = Get.put<QRScannerController>(QRScannerController());
    return SingleChildScrollView(
      child: Container(
        height: Get.height * 0.8,
        width: Get.width,
        color: Colors.transparent,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/in_app_images/scan_qr_code.png',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                width: Get.width * 0.9,
                height: Get.height * 0.55,
              ),
            ),
            SizedBox(
              width: Get.width * 0.8,
              child: FilledButton(
                onPressed: () => scannerController.scanQr(), 
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.blue),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Text(
                        'Scan QR code',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      Icon(Icons.scanner_rounded,size: 20,color: Colors.white,)
                    ],
                  ),
                )
              ),
            )
          ],
        )
      ),
    );
  }
}