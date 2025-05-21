import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/navigator_controller/navigator_controller.dart';

import 'widgets/bottom_navigation_bar.dart';
import 'widgets/lecturer_page_views.dart';

class LecturerNavigatorScreen extends GetView<NavigatorController>{
  const LecturerNavigatorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final navigatorController = Get.put<NavigatorController>(NavigatorController());
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: Obx(() => Text(
            navigatorController.title(),
            style: TextStyle(
              color: Colors.white,
              fontSize: navigatorController.titleFontSize(),
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
            child: CustomButtomNavigationBar(navigatorController: navigatorController, controller: controller),
          )
        ]
      ),
    );
  }
}
