import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/lecturer_navigator_view.dart';
import 'package:qr_attendance_app/screens/app_screens/student_screen/student_page.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/authentication_screen/authentication_screen.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/sign_up/controller/auth_controller.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());

    return Obx((){
      if(authController.isLoading.value){
        return Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.white,)),backgroundColor: Colors.white,);
      }

      return authController.currentUser.value == null ?
        AuthenticationScreen() :
        authController.currentUser.value!.isLecturer ?
          LecturerNavigatorScreen() :
          StudentScreen();
    });
  }
}