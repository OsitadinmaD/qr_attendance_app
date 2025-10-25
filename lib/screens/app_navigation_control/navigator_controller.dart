import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class NavigatorController extends GetxController {
  //Lecturer Screen Navigation Control
  Rx<int> currentIndexL = 0.obs;
  late PageController lecturerPageController;
  GlobalKey lecturerNavigationKey = GlobalKey();

  //Student Screen Navigation Control
  RxInt currentIndexS = 0.obs;
  late PageController studentPageController;
  GlobalKey studentNavigationKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    lecturerPageController = PageController();
    studentPageController = PageController();
  }
 // Titles and fontsize for the lecturer screen
  String lecturerScreenTitle(){
    if(currentIndexL.value == 0){
      return "QR-Dentify";
    }else if(currentIndexL.value == 1){
      return 'Create Session';
    }else{
      return 'Profile';
    }
  }

  double lecturerScreenTitleFontSize(){
    return 24;
  }

  // Titles and fontsize for the student screen
  String studentScreenTitle(){
    if(currentIndexS.value == 0){
      return "QR-Dentify Available Sessions";
    }else if(currentIndexS.value == 1){
      return 'Attendance History';
    }else{
      return 'Profile';
    }
  }

  double studentScreenTitleFontSize(){
    return 24;
  }



  @override
  void onClose() {
    super.onClose();
    lecturerPageController.dispose();
    studentPageController.dispose();
  }
}