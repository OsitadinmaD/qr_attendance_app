import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/student_screen/widgets/fancy_bottom_navigation.dart';
import 'package:qr_attendance_app/screens/app_screens/student_screen/widgets/student_page_view.dart';

import '../../app_navigation_control/navigator_controller.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final NavigatorController navigatorController = Get.put(NavigatorController());
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Obx( () => Text(
            navigatorController.studentScreenTitle(),
            style: TextStyle(
              color: Colors.white,
              fontSize: navigatorController.studentScreenTitleFontSize(),
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            StudentPageView(navigatorController: navigatorController),
            Positioned(
              bottom: 0,
              child: StudentFancyBottomNavigation.fancyBottomNavigation(context)
            )
          ],
        )
      ),

    );
  }

  
}