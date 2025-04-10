import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/constants/colors.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/qr_code_generate_screen/qr_generate_screen.dart';

class LecturerHomeScreen extends StatelessWidget {
  const LecturerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Center(
            child: FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blueGrey)
              ),
              onPressed: () => Get.to(()=> QrGenerateScreen()), 
              child: Text(
                'Generate QR code',
                style: TextStyle(
                  color: PColors.white,
                ),
              )
            ),
          ),
        )
      ),
    );
  }
}