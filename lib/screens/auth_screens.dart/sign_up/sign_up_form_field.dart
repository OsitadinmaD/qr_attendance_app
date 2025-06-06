import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/sign_up/controller/sign_up_controller.dart';


class SignUpFormField extends GetView<SignUpController> {
  const SignUpFormField({super.key});

  @override
  Widget build(BuildContext context) {
    final signUpController = Get.put<SignUpController>(SignUpController());
    return Scaffold(
      body: SafeArea(
        child: signUpController.signUpPageUI(context)
      ),
    );
  }
}