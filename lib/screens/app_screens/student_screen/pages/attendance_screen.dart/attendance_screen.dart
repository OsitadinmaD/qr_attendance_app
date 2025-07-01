import 'package:flutter/material.dart';


class StudentAttendanceScreen extends StatefulWidget {
  const StudentAttendanceScreen({super.key});

  @override
  State<StudentAttendanceScreen> createState() => _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  //late TabController tabController;

  @override
  void initState() {
    super.initState();
    //tabController = TabController(length: 2, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        child: Center(
          child: Text(
            'Attendance and Graph screen',
          )
        )
      ),
    );
  }
}