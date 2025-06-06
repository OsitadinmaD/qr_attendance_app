import 'package:flutter/material.dart';
import 'package:get/get.dart';


class StudentAttendanceScreen extends StatelessWidget {
  const StudentAttendanceScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.8,
      width: Get.width,
      color: Colors.transparent,
      child: Center(
        child: Text(
          'Attendance Taken'
        ),
      ),
    );
  }
}