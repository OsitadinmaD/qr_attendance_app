
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/student_screen/pages/student_profile/sub_screens/edit_profile_screen.dart';

import '../../../../../auth_screens.dart/login_screen/controller/login_controller.dart';
import '../../../../lecturer_screen/home/pages/profile/widgets/sign_out_dialog.dart';
import '../sub_screens/feedback_screen.dart';

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
          height: MediaQuery.of(context).size.height * 0.25,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: List.filled(1, BoxShadow(color: Theme.of(context).primaryColor,blurRadius: 1,spreadRadius: 0.5))
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ListTile(
                  onTap: () => Get.to(() => EditProfileScreen()),
                  title: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,size: 22,),
                ),
                Divider(color: Theme.of(context).primaryColor,height: 0.5,),
                ListTile(
                  onTap: () => Get.to(() => FeedbackScreen()),
                  title: Text(
                    'FeedBack',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,size: 22,),
                ),
                Divider(color: Theme.of(context).primaryColor,height: 0.5,),
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