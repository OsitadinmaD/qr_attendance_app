import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/lecturer_home.dart';

class LoginController extends GetxController {

  late GlobalKey<FormState> loginFormState; 

  late TextEditingController emailTextController;
  late TextEditingController passwordTextController;

  var email = ''.obs;
  var password = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loginFormState = GlobalKey<FormState>();
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
  }

  String? validateEmail(String email){
    if(!GetUtils.isEmail(email)){
      return 'Provide valid email';
    }
    return null;
  }

  String? validatePassword(String password){
    if(password.length < 6){
      return 'Password should contain at least six characters';
    }
    return null;
  }

  void validateForm(){
    final bool isValidated = loginFormState.currentState!.validate();

    if(!isValidated){
      return ;
    }
    loginFormState.currentState!.save();
    Get.to(() => LecturerHomeScreen());
  }



  @override
  void onClose() {
    super.onClose();
    emailTextController.dispose();
    passwordTextController.dispose();
    loginFormState.currentContext?.mounted == false; 
  }


}