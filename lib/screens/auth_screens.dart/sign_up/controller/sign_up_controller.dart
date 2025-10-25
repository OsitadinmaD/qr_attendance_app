import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/constants/helpers/snackbar_message_show.dart';

class SignUpController extends GetxController {
  late TextEditingController nameTextController;
  late TextEditingController idNumberTextController;
  late TextEditingController emailTextController;
  late TextEditingController passwordTextController;
  late TextEditingController departmentTextController;

  
  final isLecturer = false.obs;
  final isLoading = false.obs;
  final obscurePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    nameTextController = TextEditingController();
    idNumberTextController = TextEditingController();
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    departmentTextController =TextEditingController();
  }

  Future<void> signUp() async{
      isLoading.value = true;
      try {
        // creating user firebase auth
        UserCredential userAuth = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextController.text.trim(), 
          password: passwordTextController.text.trim()
        );

        // Save additional user data in firestore
        await FirebaseFirestore.instance.collection('usersData')
        .doc(userAuth.user!.uid)
        .set({
          'userId':userAuth.user!.uid,
          'idNumber': idNumberTextController.text.toUpperCase().trim(),
          'email': emailTextController.text.toUpperCase().trim(),
          'name': nameTextController.text.toUpperCase().trim(),
          'isLecturer': isLecturer.value,
          'department': departmentTextController.text.toUpperCase().trim(),
          'createdAt': FieldValue.serverTimestamp()
        }).whenComplete(() => SnackbarMessageShow.successSnack(
          title: 'Success', 
          message: 'Account Created Successfully \nProceed to login', 
          ),
        ).onError((error, stackTrace) => SnackbarMessageShow.errorSnack(
          title: 'Error', 
          message: 'An Unexpected error occurred', 
         ),
        );
      } on FirebaseAuthException catch (e) {
          SnackbarMessageShow.errorSnack(title: 'Error',message: _getErrorMessage(e.code),);
          //throw FirebaseAuthException(code: e.code,message: errorMessage);
        } catch (e) {
          SnackbarMessageShow.errorSnack(title: 'Error',message: 'Something went wrong',);
      } finally{
          isLoading.value = false;
    }
  }

  String _getErrorMessage(String code){
    switch(code){
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'id-already-exists':
        return 'ID number already in use.';
      default:
        return 'Sign-up failed: $code, \nplease try again.';
    }
  }

  @override
  void onClose() {
    super.onClose();
    nameTextController.clear();
    //nameTextController.dispose();
    idNumberTextController.clear();
    //idNumberTextController.dispose();
    emailTextController.clear();
    //emailTextController.dispose();
    passwordTextController.clear();
    //passwordTextController.dispose();
    departmentTextController.clear();
    //departmentTextController.dispose();
  }
}