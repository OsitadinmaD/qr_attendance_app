import 'package:get/get.dart';

class SignUpValidators {
  const SignUpValidators._();

  static String? validateEmail(String email){
    if(!GetUtils.isEmail(email)){
      return 'Provide a valid email';
    }
    return null;
  }

  static String? validateRole(String role){
    if(role == "Select Role"){
      return 'Please select your role';
    }
    return null;
  }

  static String? validateName(String name){
    if(name.isEmpty){
      return 'Please enter your name';
    }
    return null;
  }

  static String? validateIdNumber(String iD){
    if(iD.isEmpty){
      return 'Your school ID is required';
    }
    return null;
  }

  static String? validatePassword(String password){
    if(password.length < 6){
      return 'Password should contain at least 6 characters';
    }
    return null;
  }
}