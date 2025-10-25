import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/user_profile_controller.dart';

class ProfilePixInfo extends StatelessWidget {
  const ProfilePixInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<UserProfileController>(UserProfileController());
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.32,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          spacing: 5,
          children: [
            CircleAvatar(
              radius: 70,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text('A',
                style: TextStyle(
                  fontSize: 70,fontWeight: FontWeight.bold,color: Colors.white
                ),
              ),
            ),
            Obx(() => Text(
                controller.userName.value.toUpperCase(),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 35
                ),
              ),
            ),
            Obx(() => Text(
                controller.userEmail.value.toLowerCase() ,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                  fontSize: 22
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}