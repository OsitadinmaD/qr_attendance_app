import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/login_screen/controller/login_controller.dart';

import '../../../constants/colors.dart';
import '../sign_up/validators/sign_up_validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginController = Get.put<LoginController>(LoginController());
  final GlobalKey<FormState> _loginFormState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _loginFormState,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              Image.asset(
                'assets/auth_screen_logo/dark_gray_attendance.png',
                fit: BoxFit.cover,
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.41,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    spacing: 5,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(color: PColors.black,fontSize: 30,fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: TextFormField(
                          controller: _loginController.emailTextController,
                          decoration: InputDecoration(
                            iconColor: Colors.black,                              contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            hintText: 'example@mail.com',
                            hintStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Icon(Icons.email_rounded, size: 20,),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (newEmail) {
                            _loginController.emailTextController.text = newEmail!;
                          },
                          validator: (email) => SignUpValidators.validateEmail(email!),
                        ),
                      ),
                      Obx( () => SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: TextFormField(
                          controller: _loginController.passwordTextController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () => _loginController.obscurePassword.value = !_loginController.obscurePassword.value, 
                                icon: Icon(
                                  _loginController.obscurePassword.value ?
                                  Icons.visibility_off_rounded :
                                  Icons.visibility_rounded,
                                  color: Colors.grey,
                                   size: 20,
                                )
                              ),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              hintText: 'xxxxxx',
                              hintStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              prefixIcon: Icon(Icons.password_rounded, size: 20,),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            onSaved: (newPassword) {
                              _loginController.passwordTextController.text = newPassword!;
                            },
                            validator: (password) => SignUpValidators.validatePassword(password!),
                            obscureText: _loginController.obscurePassword.value,
                            obscuringCharacter: '*',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: context.width,
                        child: Obx( () => FilledButton(
                          style: ButtonStyle(
                            backgroundColor: _loginController.isLoading.value ? WidgetStatePropertyAll(Colors.grey) : WidgetStatePropertyAll(Colors.blue)
                          ),
                          onPressed: _loginController.isLoading.value ? null : () async => await _login(),
                          child: _loginController.isLoading.value ?
                            CircularProgressIndicator(color: Colors.white,) :
                            Text(
                              'Login',
                              style: TextStyle(color: PColors.white,fontSize: 20,fontWeight: FontWeight.w500),
                            )                      
                          ),
                        ),          
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ),
      );
  }

  Future<void> _login() async {
    _loginFormState.currentState!.save();
    if(_loginFormState.currentState!.validate()){
      await _loginController.loginAuth();
    }
  }
}