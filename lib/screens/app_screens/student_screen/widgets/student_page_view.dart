import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/student_screen/pages/sessions/controller/active_sessions_controller.dart';

import '../../../app_navigation_control/navigator_controller.dart';
import '../pages/attendance_screen.dart/attendance_screen.dart';
import '../pages/sessions/controller/attendance_controller.dart';
import '../pages/sessions/sessions.dart';
import '../pages/student_profile/student_profile.dart';

class StudentPageView extends StatelessWidget {
  const StudentPageView({
    super.key,
    required this.navigatorController,
  });

  final NavigatorController navigatorController;

  @override
  Widget build(BuildContext context) {
    Get.put<ActiveSessionsController>(ActiveSessionsController());
    Get.put(AttendanceController());
    return SizedBox.expand(
      child: PageView(
        allowImplicitScrolling: false,
        controller: navigatorController.studentPageController,
        physics: ScrollPhysics(
          parent: NeverScrollableScrollPhysics()
        ),
        key: navigatorController.studentNavigationKey,
        children: [
          StudentSessionsJoin(),
          AttendanceHistory(),
          StudentProfilePage(),
        ],
      ),
    );
  }
}