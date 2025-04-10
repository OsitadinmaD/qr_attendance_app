import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/constants/colors.dart';
import 'package:qr_attendance_app/constants/sizes.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/controller/qr_controller.dart';

class QrGenerateScreen extends StatelessWidget {
  const QrGenerateScreen({super.key});
  
  

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formState = GlobalKey<FormState>();
    final QrController qrController = Get.put<QrController>(QrController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Generate QR code',
          style: TextStyle(color: PColors.black),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Column(
                  spacing: 20,
                  children: [
                    qrController.generateQrCode(),
                    Form(
                      key: formState,
                      child: Column(
                        spacing: 40,
                        children: [
                          SizedBox(
                            width: PSizes.screenWidth(context) * 0.8,
                            child: TextFormField(
                              controller: TextEditingController(),
                              focusNode: FocusNode(),
                              autocorrect: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'CSC 407',
                                labelText: 'Class session Id',
                              ),
                            ),
                          )
                        ],
                    
                      )
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}