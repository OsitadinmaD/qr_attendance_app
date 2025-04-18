import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class NavigatorController extends GetxController {
  Rx<int> currentIndex = 0.obs;
  late PageController pageController;
  GlobalKey navigationKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  String title(){
    if(currentIndex.value == 0){
      return "QR-Dentify";
    }else if(currentIndex.value == 1){
      return 'Create Session';
    }else if(currentIndex.value == 2){
      return 'Attendance';
    }else{
      return 'Profile';
    }
  }

  double titleFontSize(){
    if(currentIndex.value == 0){
      return 30;
    }else if(currentIndex.value == 1){
      return 25;
    }else if(currentIndex.value == 2){
      return 25;
    }else{
      return 25;
    }
  }



  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
  }
}