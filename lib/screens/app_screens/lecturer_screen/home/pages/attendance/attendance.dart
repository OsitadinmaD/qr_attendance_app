import 'package:flutter/material.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          'Attendance',
          style: TextStyle(
            fontSize: 30
          ),
        ),
      ),
    );
  }
}
