import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/login_screen/login_form_field.dart';

import '../../../../constants/colors.dart';

class SignUpController extends GetxController {

  final GlobalKey<FormState> signUpFormState = GlobalKey<FormState>();
  
  List<String> roles = ["Select Role", "Student", 'Lecturer'];

  late TextEditingController nameTextController;
  late TextEditingController idNumberTextController;
  late TextEditingController emailTextController;
  late TextEditingController passwordTextController;

  var name = ''.obs;
  var idNumber = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var role = ' '.obs;


  @override
  void onInit() {
    super.onInit();
    nameTextController = TextEditingController();
    idNumberTextController = TextEditingController();
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
  }


  String? validateEmail(String email){
    if(!GetUtils.isEmail(email)){
      return 'Provide a valid email';
    }
    return null;
  }

  String? validateRole(String role){
    if(role == "Select Role"){
      return 'Please select your role';
    }
    return null;
  }

  String? validateName(String name){
    if(name.isEmpty){
      return 'Please enter your name';
    }
    return null;
  }

  String? validateIdNumber(String iD){
    if(iD.isEmpty){
      return 'Your school ID is paramount';
    }
    return null;
  }

  String? validatePassword(String password){
    if(password.length < 6){
      return 'Password should contain at least 6 characters';
    }
    return null;
  }

  void validateForm(){
    final bool isValidated = signUpFormState.currentState!.validate();

    if(!isValidated){
      return;
    }
    signUpFormState.currentState!.save();
    Get.to(() => LoginFormField());
  }

  Row userRole() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Role:  ',
          style: TextStyle(
            color: PColors.black, fontSize: 23),
        ),
        SizedBox(
          width: Get.context!.width * 0.7,
          child: DropdownButtonFormField(
            dropdownColor: Colors.white,
            focusColor: Colors.white,
            style: TextStyle(
              color: PColors.black, fontSize: 20),
            value: role.value,
            items: roles.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    color: PColors.black,
                    fontSize: 20),
                ),
              );
            }).toList(),
            onChanged: (userRole) {
              role.value = userRole!;
               //= dropDownValue;
            },
            validator: (role) => validateRole(role.toString()),
            hint: Text(
              'Role ',
              style: TextStyle(
                color: PColors.black, fontSize: 20),
              ),
          ),
        ),
      ],
    );
  }



  @override
  void onClose() {
    super.onClose();
    nameTextController.dispose();
    idNumberTextController.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    
  }

}