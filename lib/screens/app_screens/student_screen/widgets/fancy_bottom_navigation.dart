import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_navigation_control/navigator_controller.dart';

class StudentFancyBottomNavigation {
  StudentFancyBottomNavigation._();

  static Widget fancyBottomNavigation(BuildContext context){
    final NavigatorController navigatorController = Get.find<NavigatorController>();
    return Container(
      height: Get.height * 0.125,
      width: Get.width,
      color: Colors.transparent,
      child: FancyBottomNavigation(
        tabs: [
          TabData(iconData: Icons.now_widgets_rounded, title: 'Sessions'),
          // chart => Icons.showChart
          TabData(iconData: Icons.scanner_rounded, title: 'Scan'),
          TabData(iconData: Icons.newspaper_outlined, title: 'Record'),
          TabData(iconData: Icons.account_box_rounded, title: 'Profile')
        ], 
        onTabChangedListener: (currentIndex){
          navigatorController.currentIndexS.value = currentIndex;
          navigatorController.studentPageController.jumpToPage(currentIndex);
        },
        activeIconColor: Colors.white,
        inactiveIconColor: Colors.grey,
        circleColor: Colors.blue,
        textColor: Colors.blue,
        initialSelection: navigatorController.currentIndexS.value,
      ),
    );
  }
}