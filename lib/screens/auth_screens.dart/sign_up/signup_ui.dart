import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/sign_up/controller/sign_up_controller.dart';

import '../../../constants/colors.dart';
import 'validators/sign_up_validators.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _signUpFormState = GlobalKey<FormState>();
  final _signUpController = Get.put<SignUpController>(SignUpController());
  @override
  Widget build(BuildContext context) {
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
                          controller: _signUpController.nameTextController,
                          validator: (newName) => SignUpValidators.validateName(newName!),
                          onSaved: (newName) {
                            _signUpController.nameTextController.text = newName!;
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
                          controller: _signUpController.departmentTextController,
                          validator: (department) => SignUpValidators.validateIdNumber(department!) ,
                          onSaved: (newDepartment) {
                            _signUpController.departmentTextController.text = newDepartment!;
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
                          controller: _signUpController.idNumberTextController,
                          validator: (newIdNmuber) => SignUpValidators.validateIdNumber(newIdNmuber!) ,
                          onSaved: (newIDNumber) {
                            _signUpController.idNumberTextController.text = newIDNumber!;
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
                          controller: _signUpController.emailTextController,
                          validator: (email) => SignUpValidators.validateEmail(email!),
                          onSaved: (newEmail) {
                            _signUpController.emailTextController.text = newEmail!;
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
                            controller: _signUpController.passwordTextController,
                            validator: (password) => SignUpValidators.validatePassword(password!),
                            onSaved: (newPassword) {
                              _signUpController.passwordTextController.text = newPassword!;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'xxxxxx',
                              hintStyle: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.w500),
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.grey,fontSize: 18,fontWeight: FontWeight.w500),
                              prefixIcon: Icon(Icons.password_rounded, size: 20,),
                              suffixIcon: IconButton(
                                  onPressed: () => _signUpController.obscurePassword.value = !_signUpController.obscurePassword.value, 
                                  icon: Icon(
                                    _signUpController.obscurePassword.value ?
                                    Icons.visibility_off_rounded :
                                    Icons.visibility_rounded,
                                    color: Colors.grey,
                                    size: 20,
                                  )
                                )
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _signUpController.obscurePassword.value,
                            obscuringCharacter: '*',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: context.width,
                        child: Obx( () => FilledButton(
                          style: ButtonStyle(
                            backgroundColor: _signUpController.isLoading.value ? WidgetStatePropertyAll(Theme.of(context).primaryColorLight) : WidgetStatePropertyAll(Theme.of(context).primaryColor) 
                          ),
                          onPressed: _signUpController.isLoading.value  ? null : () async => await signUp(),
                          child: _signUpController.isLoading.value ? 
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
                      style: TextStyle(color: PColors.black,fontSize: 14,fontWeight: FontWeight.w500),
                      
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

  Future<void> signUp() async {
    _signUpFormState.currentState!.save();
    if(_signUpFormState.currentState!.validate()){
      await _signUpController.signUp();
    }
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
            child: DropdownButtonFormField<bool>(
              dropdownColor: Colors.white,
              focusColor: Colors.white,
              style: TextStyle(color: PColors.black, fontSize: 20),
              value: _signUpController.isLecturer.value,
              items: [
                DropdownMenuItem(
                  value: true,
                  child: Text(
                    'Lecturer',
                    style: TextStyle(color: PColors.black, fontSize: 20),
                  )
                ),
                DropdownMenuItem(
                  value: false,
                  child: Text(
                    'Student',
                    style: TextStyle(color: PColors.black, fontSize: 20),
                  )
                )
              ],
              onChanged: (userRole) {
                _signUpController.isLecturer.value = userRole!;
                 //= dropDownValue;
              },
              //validator: (role) => SignUpValidators.validateRole(role.toString()),
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
}