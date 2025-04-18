import 'package:flutter/material.dart';

import '../navigator_controller/navigator_controller.dart';
import '../pages/attendance/attendance.dart';
import '../pages/my_sessions/my_sessions.dart';
import '../pages/new_sessions/new_sessions.dart';
import '../pages/profile/profile.dart';

class LecturerPageViews extends StatelessWidget {
  const LecturerPageViews({
    super.key,
    required this.navigatorController,
  });

  final NavigatorController navigatorController;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: PageView(
        controller: navigatorController.pageController,
        physics: ScrollPhysics(
          parent: NeverScrollableScrollPhysics(),
        ),
        children: [ 
          MySessionsPage(),
          NewSessionsPage(),
          AttendancePage(),
          ProfilePage()
        ],
      ),
    );
  }
}