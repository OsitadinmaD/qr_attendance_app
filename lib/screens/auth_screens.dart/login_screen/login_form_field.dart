import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/constants/colors.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/login_screen/controller/login_controller.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/sign_up_sceen/sign_up_form_field.dart';

class LoginFormField extends StatelessWidget {
  const LoginFormField({super.key});

  @override
  Widget build(BuildContext context) {
    final loginFormController = Get.put<LoginController>(LoginController());
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(16.0),
          width: context.width,
          height: context.height,
          color: PColors.white,
          child: SingleChildScrollView(
            child: Form(
              key: loginFormController.loginFormState,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                spacing: 20,
                children: [
                  Image.asset(
                    'assets/auth_screen_logo/dark_gray_attendance.png',
                    fit: BoxFit.cover,
                  ),
                  Text(
                    'Login',
                    style: TextStyle(color: PColors.black,fontSize: 40,fontWeight: FontWeight.w600),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      hintText: 'example@mail.com',
                      hintStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Icon(Icons.email_rounded, size: 20,),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (newEmail) {
                      loginFormController.email.value = newEmail!;
                    },
                    validator: (email) => loginFormController.validateEmail(email!),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      hintText: 'xxxxxx',
                      hintStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Icon(Icons.password_rounded, size: 20,),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    onSaved: (newPassword) {
                      loginFormController.email.value = newPassword!;
                    },
                    validator: (password) => loginFormController.validatePassword(password!),
                  ),
                  SizedBox(
                    width: context.width,
                    child: FilledButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blueGrey)
                      ),
                      onPressed: (){
                        loginFormController.validateForm();
                      }, 
                      child: Text(
                        'Login',
                        style: TextStyle(color: PColors.white,fontSize: 20,fontWeight: FontWeight.w500),
                      )
                    ),
                  ),
                  Row(
                    //spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account yet ?',
                        style: TextStyle(color: PColors.black,fontSize: 20,fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                        onPressed: () => Get.to(() => SignUpFormField()), 
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                          ),
                        )
                      )
                    ],
                  )
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}