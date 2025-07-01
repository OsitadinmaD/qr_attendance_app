import 'package:flutter/material.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Attendance',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600
        ),
      ),
    );
  }
}