import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/login_screen/login_form_field.dart';

import '../../../../constants/colors.dart';

class SignUpController extends GetxController {

  late final GlobalKey<FormState> _signUpFormState;
  
  List<String> roles = ["Select Role", "Student", 'Lecturer'];

  late TextEditingController _nameTextController;
  late TextEditingController _idNumberTextController;
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;

  final _name = ''.obs;
  final _idNumber = ''.obs;
  final _email = ''.obs;
  final _password = ''.obs;
  final _role = 'Select Role'.obs;
  final _isLoading = false.obs;
  final _obscurePassword = true.obs;


  @override
  void onInit() {
    super.onInit();
    _signUpFormState = GlobalKey<FormState>();
    _nameTextController = TextEditingController();
    _idNumberTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
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
      return 'Your school ID is required';
    }
    return null;
  }

  String? validatePassword(String password){
    if(password.length < 6){
      return 'Password should contain at least 6 characters';
    }
    return null;
  }

  Future<void> _signUp() async{
    _signUpFormState.currentState!.save();
    if(_signUpFormState.currentState!.validate()){
      _isLoading.value = true;
      try {
        // creating user firebase auth
        UserCredential userAuth = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.value.trim(), 
          password: _password.value.trim()
        );

        if(userAuth.user != null){
          Get.to(() => LoginFormField());
        }
        // Save additional user data in firestore
        await FirebaseFirestore.instance.collection('users')
        .doc(userAuth.user!.uid)
        .set({
          'userId': _idNumber.value.trim(),
          'email': _email.value.trim(),
          'name': _name.value.trim(),
          'role': _role.value.trim(),
          'password': _password.value.trim(),
          //department: department
        });
        // ignore: avoid_print
        print('Sign-Up Successful');
      } on FirebaseAuthException catch (e) {
          _showErrorMessage(message: _getErrorMessage(e.code));
          //throw FirebaseAuthException(code: e.code,message: errorMessage);
        } catch (e) {
            _showErrorMessage(message: 'An unexpected error occurred');
      } finally{
          _isLoading.value = false;
      }
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

  void _showErrorMessage({required String message}){
    Get.snackbar(
      'Error', message,
      colorText: Colors.white,
      backgroundColor: Colors.red,
      mainButton: TextButton(
        onPressed: () => Get.back(), 
        child: Text(
          'Close',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600
          ),
        )
      ),          
      snackPosition: SnackPosition.TOP,
      animationDuration: Duration(seconds: 5),
      icon: Icon(Icons.error_outline_rounded,size: 25, color: Colors.white,)
    );
  }

  Widget signUpPageUI(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(16),
        width: context.width,
        height: context.height,
        child: SingleChildScrollView(
          child: Form(
            key: _signUpFormState,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              spacing: 3,
              children: [
                SizedBox(height: 10,),
                Container(
                  height: MediaQuery.of(context).size.height*0.6,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade200,
                      borderRadius: BorderRadius.circular(20)
                    ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Create an account',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(color: PColors.black, fontSize: 30,fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: TextFormField(
                            controller: _nameTextController,
                            validator: (newName) => validateName(newName!),
                            onSaved: (newName) {
                              _name.value = newName!;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Name',
                              hintStyle: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.w500),
                              labelText: 'Name',
                              labelStyle: TextStyle(color: Colors.grey,fontSize:18,fontWeight: FontWeight.w500),
                              prefixIcon: Icon(Icons.boy_rounded, size: 20,)
                            ),
                            keyboardType: TextInputType.name,
                          ),
                        ),
                        userRole(context),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: TextFormField(
                            controller: _idNumberTextController,
                            validator: (newIdNmuber) => validateIdNumber(newIdNmuber!) ,
                            onSaved: (newIDNumber) {
                              _idNumber.value = newIDNumber!;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'xxx21xxx129',
                              hintStyle: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.w500),
                              labelText: 'ID Number',
                              labelStyle: TextStyle(color: Colors.grey,fontSize: 18,fontWeight: FontWeight.w500),
                              prefixIcon: Icon(Icons.perm_identity_rounded, size: 20,)
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: TextFormField(
                            controller: _emailTextController,
                            validator: (email) => validateEmail(email!),
                            onSaved: (newEmail) {
                              _email.value = newEmail!;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'example@mail.com',
                              hintStyle: TextStyle(color: Colors.grey,fontSize:15,fontWeight: FontWeight.w500),
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.grey,fontSize: 18,fontWeight: FontWeight.w500),
                              prefixIcon: Icon(Icons.email_rounded, size: 20,)
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: Obx(() => TextFormField(
                              controller: _passwordTextController,
                              validator: (password) => validatePassword(password!),
                              onSaved: (newPassword) {
                                _password.value = newPassword!;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'xxxxxx',
                                hintStyle: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.w500),
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.grey,fontSize: 18,fontWeight: FontWeight.w500),
                                prefixIcon: Icon(Icons.password_rounded, size: 20,),
                                suffixIcon: IconButton(
                                    onPressed: () => _obscurePassword.value = !_obscurePassword.value, 
                                    icon: Icon(
                                      _obscurePassword.value ?
                                      Icons.visibility_off_rounded :
                                      Icons.visibility_rounded,
                                      color: Colors.grey,
                                      size: 20,
                                    )
                                  )
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: _obscurePassword.value,
                              obscuringCharacter: '*',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: context.width,
                          child: Obx( () => FilledButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Colors.blueGrey)
                            ),
                            onPressed: () => _isLoading.value ? null : _signUp(),
                            child: _isLoading.value ? 
                              CircularProgressIndicator(color: Colors.white,) :
                              Text(
                                'Sign up',
                                style: TextStyle(
                                  color: PColors.white,fontSize: 20,fontWeight: FontWeight.w600
                                ),
                              )
                            ),
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
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

  Widget userRole(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width ,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Role:  ',
            style: TextStyle(
              color: PColors.black, fontSize: 23),
          ),
          SizedBox(
            width: Get.context!.width * 0.6,
            child: DropdownButtonFormField(
              dropdownColor: Colors.white,
              focusColor: Colors.white,
              style: TextStyle(
                color: PColors.black, fontSize: 20),
              value: _role.value,
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
                _role.value = userRole!.toString();
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
      ),
    );
  }



  @override
  void onClose() {
    super.onClose();
    _nameTextController.dispose();
    _idNumberTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
  }

}