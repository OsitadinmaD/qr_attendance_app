import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/constants/colors.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/login_screen/login_form_field.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/sign_up_sceen/controller/sign_up_controller.dart';


class SignUpFormField extends StatelessWidget {
  const SignUpFormField({super.key});

  @override
  Widget build(BuildContext context) {
    final signUpController = Get.put<SignUpController>(SignUpController());
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(16),
          width: context.width,
          height: context.height,
          child: SingleChildScrollView(
            child: Form(
              key: signUpController.signUpFormState,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                spacing: 10,
                children: [
                  SizedBox(height: 20,),
                  Text(
                    'Create an account',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(height: 0.8,color: PColors.black, fontSize: 80,fontWeight: FontWeight.w600),
                  ),
                  TextFormField(
                    controller: signUpController.nameTextController,
                    validator: (newName) => signUpController.validateName(newName!),
                    onSaved: (newName) {
                      signUpController.name.value = newName!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Name',
                      hintStyle: TextStyle(color: Colors.grey,fontSize: 20,fontWeight: FontWeight.w500),
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.grey,fontSize: 20,fontWeight: FontWeight.w500),
                      prefix: Icon(Icons.boy_rounded)
                    ),
                    keyboardType: TextInputType.name,
                  ),
                  signUpController.userRole(),
                  TextFormField(
                    controller: signUpController.idNumberTextController,
                    validator: (newIdNmuber) => signUpController.validateIdNumber(newIdNmuber!) ,
                    onSaved: (newIDNumber) {
                      signUpController.idNumber.value = newIDNumber!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'xxx21xxx129',
                      hintStyle: TextStyle(color: Colors.grey,fontSize: 20,fontWeight: FontWeight.w500),
                      labelText: 'ID Number',
                      labelStyle: TextStyle(color: Colors.grey,fontSize: 20,fontWeight: FontWeight.w500),
                      prefix: Icon(Icons.perm_identity_rounded)
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  TextFormField(
                    controller: signUpController.emailTextController,
                    validator: (email) => signUpController.validateEmail(email!),
                    onSaved: (newEmail) {
                      signUpController.email.value = newEmail!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'example@mail.com',
                      hintStyle: TextStyle(color: Colors.grey,fontSize: 20,fontWeight: FontWeight.w500),
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.grey,fontSize: 20,fontWeight: FontWeight.w500),
                      prefix: Icon(Icons.email_rounded)
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    controller: signUpController.passwordTextController,
                    validator: (password) => signUpController.validatePassword(password!),
                    onSaved: (newPassword) {
                      signUpController.password.value = newPassword!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'xxxxxx',
                      hintStyle: TextStyle(color: Colors.grey,fontSize: 20,fontWeight: FontWeight.w500),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.grey,fontSize: 20,fontWeight: FontWeight.w500),
                      prefix: Icon(Icons.password_rounded)
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  SizedBox(
                    width: context.width,
                    child: FilledButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blueGrey)
                      ),
                      onPressed: (){
                        signUpController.validateForm();
                      }, 
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                          color: PColors.white,fontSize: 20,fontWeight: FontWeight.w600
                        ),
                      )
                    ),
                  ),
                  Row(
                    //spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account ?',
                        style: TextStyle(color: PColors.black,fontSize: 20,fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                        onPressed: () => Get.to(() => LoginFormField()), 
                        child: Text(
                          'Sign in',
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
        )
      ),
    );
  }
}