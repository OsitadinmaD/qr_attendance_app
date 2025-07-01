import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/lecturer_navigator_view.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/pages/my_sessions/controller/sessions_controller.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/authentication_screen/authentication_screen.dart';
//import 'package:qr_attendance_app/firebase_options.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/login_screen/controller/login_controller.dart';
//import 'package:qr_attendance_app/screens/auth_screens.dart/sign_up/sign_up_form_field.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((_){
    Get.put<LoginController>(LoginController());//initialize login controller
    Get.put<SessionsController>(SessionsController());//Initialize Sessions Controller
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance Authentication App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Obx((){
        final authController = Get.find<LoginController>();
        return authController.user.value != null ? LecturerNavigatorScreen() : AuthenticationScreen();
      })
    );
  }
}
