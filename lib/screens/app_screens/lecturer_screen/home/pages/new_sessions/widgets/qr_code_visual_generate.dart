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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Divider(color: Theme.of(context).colorScheme.primary,),
              Text(
                'Visualize generated QR code (optional)',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Divider(color: Theme.of(context).colorScheme.primary,),
              const SizedBox(height: 10,),
            Obx( () => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => qrCodeController.qrCodeID(), 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: qrCodeController.toggleQrInputs() ? 
                      Theme.of(context).colorScheme.primary : Theme.of(context).primaryColorLight,
                  ),
                  child: Text(
                    'Visualize QR',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.15,
                  child: qrCodeController.generateQrCode()
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