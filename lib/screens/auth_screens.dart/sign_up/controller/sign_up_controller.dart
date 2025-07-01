import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/sign_up/validators/sign_up_validators.dart';
import 'package:uuid/uuid.dart';

import '../../../../constants/colors.dart';
import '../widgets/snackbar_message_show.dart';

class SignUpController extends GetxController {

  late final GlobalKey<FormState> _signUpFormState;
  
  List<String> roles = ["Select Role", "Student", 'Lecturer'];

  late TextEditingController _nameTextController;
  late TextEditingController _idNumberTextController;
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;
  late TextEditingController _departmentTextController;

  
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
    _departmentTextController =TextEditingController();
  }

  Future<void> _signUp() async{
    _signUpFormState.currentState!.save();
    if(_signUpFormState.currentState!.validate()){
      _isLoading.value = true;
      try {
        // creating user firebase auth
        UserCredential userAuth = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailTextController.text.trim(), 
          password: _passwordTextController.text.trim()
        );

        final userId = Uuid().v4();
        // Save additional user data in firestore
        await FirebaseFirestore.instance.collection('usersData')
        .doc(userAuth.user!.uid)
        .set({
          'userId':userId,
          'idNumber': _idNumberTextController.text.toUpperCase().trim(),
          'email': _emailTextController.text.toUpperCase().trim(),
          'name': _nameTextController.text.toUpperCase().trim(),
          'role': _role.value.toUpperCase().trim(),
          'password': _passwordTextController.text.trim(),
          'department': _departmentTextController.text.toUpperCase().trim(),
          'createdAt': FieldValue.serverTimestamp()
        }).whenComplete(() => snackBarshow(
          title: 'Success', 
          message: 'Account Created Successfully \nProceed to login', 
          backgroundColor: Colors.green, 
          icon: Icons.check_circle
          ),
        ).onError((error, stackTrace) => snackBarshow(
          title: 'Error', 
          message: 'An Unexpected error occurred', 
          backgroundColor: Colors.red, 
          icon: Icons.error_outline_outlined
         ),
        );
      } on FirebaseAuthException catch (e) {
          snackBarshow(title: 'Error',message: _getErrorMessage(e.code),backgroundColor: Colors.red,icon: Icons.error_outline_rounded);
          //throw FirebaseAuthException(code: e.code,message: errorMessage);
        } catch (e) {
          snackBarshow(title: 'Error',message: 'Something went wrong',backgroundColor: Colors.red,icon: Icons.error_outline_rounded);
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

  Widget signUpPageUI(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _signUpFormState,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            spacing: 3,
            children: [
              SizedBox(height: 10,),
              Container(
                height: MediaQuery.of(context).size.height*0.67,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
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
                          validator: (newName) => SignUpValidators.validateName(newName!),
                          onSaved: (newName) {
                            _nameTextController.text = newName!;
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
                          controller: _departmentTextController,
                          validator: (department) => SignUpValidators.validateIdNumber(department!) ,
                          onSaved: (newDepartment) {
                            _departmentTextController.text = newDepartment!;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'History',
                            hintStyle: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.w500),
                            labelText: 'Department',
                            labelStyle: TextStyle(color: Colors.grey,fontSize: 18,fontWeight: FontWeight.w500),
                            prefixIcon: Icon(Icons.badge_outlined, size: 20,)
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: TextFormField(
                          controller: _idNumberTextController,
                          validator: (newIdNmuber) => SignUpValidators.validateIdNumber(newIdNmuber!) ,
                          onSaved: (newIDNumber) {
                            _idNumberTextController.text = newIDNumber!;
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
                          validator: (email) => SignUpValidators.validateEmail(email!),
                          onSaved: (newEmail) {
                            _emailTextController.text = newEmail!;
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
                            validator: (password) => SignUpValidators.validatePassword(password!),
                            onSaved: (newPassword) {
                              _passwordTextController.text = newPassword!;
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
                            backgroundColor: _isLoading.value ? WidgetStatePropertyAll(Colors.grey) : WidgetStatePropertyAll(Colors.blue) 
                          ),
                          onPressed: _isLoading.value  ? null : () => _signUp(),
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
                      'Already have an account ? --- Sign in',
                      style: TextStyle(color: PColors.black,fontSize: 20,fontWeight: FontWeight.w500),
                    ),
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
              validator: (role) => SignUpValidators.validateRole(role.toString()),
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
    _departmentTextController.dispose();
  }

}