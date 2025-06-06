import 'package:flutter/material.dart';

import '../../../app_navigation_control/navigator_controller.dart';
import '../pages/attendance_screen.dart/attendance_screen.dart';
import '../pages/qr_scan_screen.dart/qr_scan_screen.dart';
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
          QrScanScreen(),
          StudentAttendanceScreen(),
          StudentProfilePage(),
        ],
      ),
    );
  }
}