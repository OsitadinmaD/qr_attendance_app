import 'package:flutter/material.dart';
import 'package:qr_attendance_app/screens/app_screens/student_screen/pages/sessions/widgets/available_sessions.dart';
import 'package:qr_attendance_app/screens/app_screens/student_screen/pages/tabbar.dart';

class StudentSessionsJoin extends StatefulWidget {
  const StudentSessionsJoin({super.key});

  @override
  State<StudentSessionsJoin> createState() => _StudentSessionsJoinState();
}

class _StudentSessionsJoinState extends State<StudentSessionsJoin> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState(){
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        child: Column(
          children: [
            SizedBox(height: 5,),
            SessionTabBarView.tabBar(
              tabController: tabController,
              tab1Label: 'Active Sessions',
              tab2Label: 'Joined Sessions',
            ),
            SessionTabBarView().sessionTabBarView(
              tab1Page: AvailableSessions().buildActiveSessionStream(),
              tab2Page: AvailableSessions().buildJoinedSessionsStream(),
              tabController: tabController
            ),
          ],
        )
      ),
    );
  }
}