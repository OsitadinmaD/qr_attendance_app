import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/pages/new_sessions/controller/new_session_controller.dart';

class QRCodeVisualGenerate extends StatelessWidget {
  const QRCodeVisualGenerate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final qrCodeController = Get.put<NewSessionController>(NewSessionController());
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        spacing: 15,
        children: [
          Obx( () => Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                boxShadow: List.filled(1, BoxShadow(color: Colors.black38,blurRadius: 1,spreadRadius: 0.5))
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.315,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: qrCodeController.generateQrCode(),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => qrCodeController.qrCodeID(),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.065,
              decoration: BoxDecoration(
                color: Colors.blue,
                //border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text(
                  'Generate QR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}