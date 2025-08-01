
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../auth_screens.dart/login_screen/controller/login_controller.dart';
import '../../../../lecturer_screen/home/pages/profile/widgets/sign_out_dialog.dart';

class StudentProfileMenuItems extends StatelessWidget {
  const StudentProfileMenuItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: List.filled(1, BoxShadow(color: Colors.black38,blurRadius: 1,spreadRadius: 0.5))
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ListTile(
                  title: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,size: 22,),
                ),
                Divider(color: Colors.grey,height: 0.5,),
                ListTile(
                  title: Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,size: 22,),
                ),
                Divider(color: Colors.grey,height: 0.5,),
                ListTile(
                  title: Text(
                    'Light/Dark Mode',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,size: 22,),
                ),
                Divider(color: Colors.grey,height: 0.5,),
                ListTile(
                  title: Text(
                    'FeedBack',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,size: 22,),
                ),
                Divider(color: Colors.grey,height: 0.5,),
                ListTile(
                  onTap: () async => await signOutDialog(context, loginController),
                  title: Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,size: 22,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}