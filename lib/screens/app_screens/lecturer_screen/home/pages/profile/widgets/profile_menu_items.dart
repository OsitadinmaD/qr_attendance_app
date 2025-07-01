import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/login_screen/controller/login_controller.dart';

class ProfileMenuItems extends StatelessWidget {
  const ProfileMenuItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final logOutController = Get.put<LoginController>(LoginController());
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
              boxShadow: List.filled(
                  1,
                  BoxShadow(
                      color: Colors.black38,
                      blurRadius: 1,
                      spreadRadius: 0.5))),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ListTile(
                  onTap: () {},
                  title: Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 28,
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 0.5,
                ),
                ListTile(
                  title: Text(
                    'Change Password',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 28,
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 0.5,
                ),
                ListTile(
                  title: Text(
                    'Light/Dark Mode',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 28,
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 0.5,
                ),
                ListTile(
                  title: Text(
                    'FeedBack',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 28,
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 0.5,
                ),
                ListTile(
                  onTap: () {
                    showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'Sign Out',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            actions: [
                              OutlinedButton(
                                style: ButtonStyle(
                                  side: WidgetStatePropertyAll(BorderSide(color: Colors.white))
                                ),
                                  onPressed: () => Get.back(),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  )),
                              FilledButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.red)),
                                onPressed: () => logOutController.logOut(),
                                child: Text(
                                  'Log Out',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                            backgroundColor: Colors.blue,
                            content: Text(
                              'Are you sure you want to log out?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        });
                  },
                  title: Text(
                    'Log Out',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
