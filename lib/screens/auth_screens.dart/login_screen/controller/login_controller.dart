import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/sign_up/validators/sign_up_validators.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/sign_up/widgets/snackbar_message_show.dart';

import '../../../../constants/colors.dart';
import '../../../app_screens/lecturer_screen/home/lecturer_navigator_view.dart';

class LoginController extends GetxController {

  late GlobalKey<FormState> _loginFormState; 
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User?> user = Rx<User?>(null);
  final RxBool _signInLoading = false.obs;

  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;

  final _email = ''.obs;
  final _password = ''.obs;
  var hide = true.obs;
  final _isLoading = false.obs;
  final _obscurePassword = true.obs;

  @override
  void onInit() {
    //listen to auth state changes (auto-login)
    _auth.authStateChanges().listen((User? user){
      this.user.value = user;
    });
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
                              validator: (email) => SignUpValidators.validateEmail(email!),
                            ),
                          ),
                          Obx( () => SizedBox(
                              height: MediaQuery.of(context).size.height * 0.08,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    onPressed: () => _obscurePassword.value = !_obscurePassword.value, 
                                    icon: Icon(
                                      _obscurePassword.value ?
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
                                  _email.value = newPassword!;
                                },
                                validator: (password) => SignUpValidators.validatePassword(password!),
                                obscureText: _obscurePassword.value,
                                obscuringCharacter: '*',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: context.width,
                            child: Obx( () => FilledButton(
                                style: ButtonStyle(
                                backgroundColor: _isLoading.value ? WidgetStatePropertyAll(Colors.grey) : WidgetStatePropertyAll(Colors.blueGrey)
                              ),
                              onPressed: _signInLoading.value ? null : () => _loginAuth(),
                              child: _isLoading.value ?
                                CircularProgressIndicator(color: Colors.white,) :
                                Text(
                                  'Login',
                                  style: TextStyle(color: PColors.white,fontSize: 20,fontWeight: FontWeight.w500),
                                )
                                                        ),
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
  
  void setLoginLoading(bool value) => _signInLoading.value = value;

  Future<void> _loginAuth() async {
    _loginFormState.currentState!.save();
    if(_loginFormState.currentState!.validate()){
      _isLoading.value = true;
      try {
        setLoginLoading(true);
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.value.trim(), 
          password: _password.value.trim()
        ).whenComplete(() => snackBarshow(
          title: 'Success', 
          message: 'Login successful', 
          backgroundColor: Colors.green, 
          icon: Icons.badge_outlined
          )
        );
        user.value = userCredential.user;
        if(userCredential.user != null){
          Future.delayed(Duration(seconds: 5));
          Get.offAll(() => LecturerNavigatorScreen());
        }
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
        setLoginLoading(false);
        _isLoading.value = false;
      }
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
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _loginFormState.currentContext?.mounted == false; 
  }
}