// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app_screens/lecturer_screen/home/lecturer_navigator_view.dart';
import '../app_screens/student_screen/student_page.dart';
import '../auth_screens.dart/authentication_screen/authentication_screen.dart';
import '../auth_screens.dart/login_screen/controller/login_controller.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LoginController _authController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    // Use WidgetsBinding to ensure the build method has completed before navigating.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToNextScreen();
    });
  }

  Future<void> _navigateToNextScreen() async {
    // 1. Wait for a minimum duration to show the splash screen
    await Future.delayed(const Duration(seconds: 3));

    // 2. Check the user's login state
    final User? user = _authController.firebaseUser.value;

    if (user == null) {
      // User is not logged in, navigate to the Login screen
      Get.offAll(() => AuthenticationScreen());
    } else {
      // 3. Check the user's role from Firestore
      try {
        final userDoc = await FirebaseFirestore.instance.collection('usersData').doc(user.uid).get();
        if (userDoc.exists) {
          final isLecturer = userDoc.data()?['isLecturer'];

          if (isLecturer == true) {
            Get.offAll(() => LecturerNavigatorScreen());
          } else if (isLecturer == false) {
            Get.offAll(() => StudentScreen());
          } else {
            // Role is unknown, log them out
            _authController.logOut();
            Get.offAll(() => AuthenticationScreen());
          }
        } else {
          // User document not found, log them out
          _authController.logOut();
          Get.offAll(() => AuthenticationScreen());
        }
      } catch (e) {
        printError(info: "Error checking user role: $e");
        _authController.logOut();
        Get.offAll(() => AuthenticationScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/auth_screen_logo/1756256050675_1.jpg',fit: BoxFit.cover,),
            const SizedBox(height: 20),
            const Text(
              'Attendance App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: Colors.blue),
          ],
        ),
      ),
    );
  }
}