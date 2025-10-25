import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/constants/helpers/snackbar_message_show.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/lecturer_navigator_view.dart';
import 'package:qr_attendance_app/screens/app_screens/student_screen/student_page.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/authentication_screen/authentication_screen.dart';


class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //Rx variable to hold the user and make it reactive
  Rx<User?> firebaseUser = Rx<User?>(null);

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

  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(_auth.authStateChanges());

    //This listener will handle navigation
    ever(firebaseUser, _setInitialScreen);
  }

  //this method determines which screen to show based on user's role
  _setInitialScreen(User? user) async {
    if(user == null){
      //User is logged out go to login screen
      Get.offAll(() => AuthenticationScreen());
    } else {
      //User is logged in, check their role
      final userDoc = await _firestore 
        .collection('usersData')
        .doc(user.uid)
        .get();
      
      if(userDoc.exists){
        final isLecturer = userDoc.data()?['isLecturer'];

        if(isLecturer == true){
          Get.offAll(() => LecturerNavigatorScreen());
        } else if(isLecturer == false){
          Get.offAll(() => StudentScreen());
        } else {
          //role is unknown 
          SnackbarMessageShow.errorSnack(title: 'Error', message: 'User data/role not found');
          return;
        }
      }
    }
  }

  Future<void> loginAuth() async {
    isLoading.value = true;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text.toLowerCase().trim(), 
        password: passwordTextController.text.trim()
      ).whenComplete(() => SnackbarMessageShow.successSnack(
        title: 'Success', 
        message: 'Login successful', 
      )
    );
    } on FirebaseAuthException catch (e) {
      SnackbarMessageShow.errorSnack(
        title: 'Error',
        message: _getErrorMessage(e.code),
      );
      //throw FirebaseAuthException(code: e.code,message: errorMessage);
    } catch (e) {
      SnackbarMessageShow.errorSnack(
        title: 'Error',
        message: 'An unexpected error occured',
      );
    }finally {
      isLoading.value = false;
    }
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
      WidgetsBinding.instance.addPostFrameCallback((_){
        Get.offAll(() => AuthenticationScreen());
      });
    } catch (e) {
      SnackbarMessageShow.errorSnack(title: 'Logout Error', message: e.toString());
    }
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
    //emailTextController.dispose();
    passwordTextController.clear();
    //passwordTextController.dispose();
  }
}