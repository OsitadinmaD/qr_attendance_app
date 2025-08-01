import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/authentication_screen/authentication_screen.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/sign_up/widgets/snackbar_message_show.dart';


class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late TextEditingController emailTextController;
  late TextEditingController passwordTextController;

  final isLoading = false.obs;
  final obscurePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
  }

  Future<void> loginAuth() async {
    isLoading.value = true;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text.toLowerCase().trim(), 
        password: passwordTextController.text.trim()
      ).whenComplete(() => snackBarshow(
        title: 'Success', 
        message: 'Login successful', 
        backgroundColor: Colors.green, 
        icon: Icons.badge_outlined
      )
    );
    } on FirebaseAuthException catch (e) {
      snackBarshow(
        title: 'Error',
        message: _getErrorMessage(e.code),
        backgroundColor: Colors.red,
        icon: Icons.error_outline_rounded
      );
      //throw FirebaseAuthException(code: e.code,message: errorMessage);
    } catch (e) {
      snackBarshow(
        title: 'Error',
        message: 'An unexpected error occured',
        backgroundColor: Colors.red,
        icon: Icons.error_outline_rounded
      );
    }finally {
      isLoading.value = false;
    }
  }

  Future<void> logOut() async {
    await _auth.signOut();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Get.offAll(() => AuthenticationScreen());
    });
  }

  String _getErrorMessage(String code){
    switch(code){
      case 'user-not-found':
        return 'No account found for this _email';
      case 'wrong-_password':
        return 'Incorrect _password';
      case 'invalid-_email':
        return 'Invalid _email Address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      default:
        return 'Login failed: $code. \nPlease try again';
    }
  }

  @override
  void onClose() {
    super.onClose();
    emailTextController.clear();
    emailTextController.dispose();
    passwordTextController.clear();
    passwordTextController.dispose();
  }
}