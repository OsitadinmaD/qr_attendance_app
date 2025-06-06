import 'package:flutter/material.dart';
import 'package:qr_attendance_app/screens/app_screens/student_screen/pages/sessions/widgets/tabbar.dart';

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
            SessionTabBarView.tabBar(tabController),
            SessionTabBarView().sessionTabBarView(tabController),
          ],
        )
      ),
    );
  }
}