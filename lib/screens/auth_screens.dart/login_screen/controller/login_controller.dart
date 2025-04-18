import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../app_screens/lecturer_screen/home/lecturer_navigator_view.dart';

class LoginController extends GetxController {

  late GlobalKey<FormState> _loginFormState; 

  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;

  final _email = ''.obs;
  final _password = ''.obs;
  var hide = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loginFormState = GlobalKey<FormState>();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  Widget loginPageUI(BuildContext context,) {
    return Container(
        width: context.width,
        height: context.height,
        color: PColors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _loginFormState,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  IconButton(
                    onPressed: () => Get.back(), 
                    icon: Icon(Icons.arrow_back_rounded, size: 30,),
                    tooltip: 'Back',
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.grey.shade200)
                    ),
                    ),
                  Image.asset(
                    'assets/auth_screen_logo/dark_gray_attendance.png',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height*0.35,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade200,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        spacing: 8,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(color: PColors.black,fontSize: 30,fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: TextFormField(
                              decoration: InputDecoration(
                                iconColor: Colors.black,
                                contentPadding: EdgeInsets.all(8),
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
                                _email.value = newEmail!;
                              },
                              validator: (email) => validateEmail(email!),
                            ),
                          ),
                          Obx( () => SizedBox(
                              height: MediaQuery.of(context).size.height * 0.08,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  suffixIcon: Obx( ()=>IconButton(
                                      onPressed: (){
                                          hide.value == false;
                                      }, 
                                      icon: Icon(hide.value == true ? Icons.remove_red_eye : Icons.hide_source_rounded, size: 20,)
                                    ),
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
                                  _email.value = newPassword!;
                                },
                                validator: (password) => validatePassword(password!),
                                obscureText: hide.value == true ? true : false ,
                                obscuringCharacter: '*',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: context.width,
                            child: FilledButton(
                              style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Colors.blueGrey)
                            ),
                            onPressed: (){
                             validateForm();
                            }, 
                            child: Text(
                              'Login',
                              style: TextStyle(color: PColors.white,fontSize: 20,fontWeight: FontWeight.w500),
                            )
                          ),           ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),
        ),
      );
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

  Future<void> loginAuth({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch(e.code){
        case 'user-not-found':
          errorMessage = 'No account found for this _email';
          break;
        case 'wrong-_password':
          errorMessage = 'Incorrect _password';
          break;
        case 'invalid-_email':
          errorMessage = 'Invalid _email Address';
          break;
        default:
          errorMessage = 'Login failed. Please try again';
      }
      throw FirebaseAuthException(code: e.code,message: errorMessage);
    }
  }

  void validateForm(){
    final bool isValidated = _loginFormState.currentState!.validate();

    if(!isValidated){
      return ;
    }
    _loginFormState.currentState!.save();
    loginAuth(email: _email.value, password: _password.value);
    Get.offAll(() => NavigatorView());
  }

  @override
  void onClose() {
    super.onClose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _loginFormState.currentContext?.mounted == false; 
  }


}