import 'package:flutter/material.dart';

import 'widgets/student_profile_items.dart';
import 'widgets/student_profile_pix_info.dart';

class StudentProfilePage extends StatelessWidget {
  const StudentProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        children: [
          StudentProfilePixInfo(),
          StudentProfileMenuItems()
        ],
      )
    );
  }
}


