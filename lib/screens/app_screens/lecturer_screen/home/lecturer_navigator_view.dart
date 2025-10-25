import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_navigation_control/navigator_controller.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/pages/my_sessions/controller/sessions_controller.dart';

import 'widgets/bottom_navigation_bar.dart';
import 'widgets/lecturer_page_views.dart';

// ignore: use_key_in_widget_constructors
class LecturerNavigatorScreen extends StatelessWidget{
  ///const LecturerNavigatorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final navigatorController = Get.put<NavigatorController>(NavigatorController());
    Get.put<SessionsController>(SessionsController());
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Obx(() => Text(
            navigatorController.lecturerScreenTitle(),
            style: TextStyle(
              color: Colors.white,
              fontSize: navigatorController.lecturerScreenTitleFontSize(),
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          LecturerPageViews(navigatorController: navigatorController),
          Positioned(
            bottom: 0,
            child: CustomButtomNavigationBar(
              navigatorController: navigatorController,
            ),
          )
        ]
      ),
    );
  }
}
