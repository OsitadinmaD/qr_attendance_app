import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app_navigation_control/navigator_controller.dart';

class CustomButtomNavigationBar extends StatelessWidget {
  const CustomButtomNavigationBar({
    super.key,
    required this.navigatorController,
  });

  final NavigatorController navigatorController;
  

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.125,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Obx(() => FancyBottomNavigation(
        tabs: [
          TabData(iconData: Icons.now_widgets_rounded, title: 'Sessions'),
          TabData(iconData: Icons.fiber_new_rounded, title: 'Create'),
          TabData(iconData: Icons.newspaper_rounded, title: 'Attendance'),
          TabData(iconData: Icons.account_box_rounded, title: 'Profile'),
        ],
        onTabChangedListener: (positionIndex) {
          navigatorController.currentIndexL.value = positionIndex;
          navigatorController.lecturerPageController.jumpToPage(positionIndex);
        },
        initialSelection: navigatorController.currentIndexL.value,
        key: navigatorController.lecturerNavigationKey,
        inactiveIconColor: Colors.grey,
        activeIconColor: Colors.white,
        circleColor: Colors.blue,
        textColor: Colors.blue,
        )
      ),
    );
  }
}