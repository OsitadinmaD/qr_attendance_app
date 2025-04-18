import 'package:flutter/material.dart';

import 'widgets/profile_menu_items.dart';
import 'widgets/profile_pix_info.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
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
          ProfilePixInfo(),
          ProfileMenuItems()
        ],
      )
    );
  }
}


