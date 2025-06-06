import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/student_screen/pages/qr_scan_screen.dart/controller/qr_scanner_controller.dart';

class MobileScannerScreen extends StatelessWidget {
  const MobileScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final QRScannerController mobileScanner = Get.put<QRScannerController>(QRScannerController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Scan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Container(
                color: Colors.white,
                height: Get.height * 0.15,
                width: Get.width * 0.85,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(), 
                      icon: Icon(Icons.arrow_back_rounded,size: 25,color: Colors.blue,),
                    ),
                    Text(
                      'Scan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              )
            ),
            Positioned(
              bottom: 100,
              child: SizedBox(
                width: Get.width * 0.8,
                height: Get.height * 0.6,
                child: mobileScanner.mobileScanner()
              ),
            ),
          ],
        ),
      ),
    );
  }
}