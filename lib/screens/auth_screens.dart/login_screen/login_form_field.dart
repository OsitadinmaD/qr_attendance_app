import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/login_screen/controller/login_controller.dart';

class LoginFormField extends GetView<LoginController> {
  const LoginFormField({super.key});

  @override
  Widget build(BuildContext context) {
    final loginFormController = Get.put<LoginController>(LoginController());
    return Scaffold(
      body: SafeArea(
        child: loginFormController.loginPageUI(context),
      ),
    );
  }
}