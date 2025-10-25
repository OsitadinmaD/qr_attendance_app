import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarMessageShow {
  SnackbarMessageShow._();

    static void errorSnack({required String title, required String message,}){
    Get.snackbar(
      title, message,
      colorText: Colors.white,
      backgroundColor: Colors.red,
      mainButton: TextButton(
        onPressed: () => Get.back(), 
        child: Text(
          'Close',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600
          ),
        )
      ),          
      snackPosition: SnackPosition.BOTTOM,
      animationDuration: Duration(seconds: 5),
      icon: Icon(Icons.error_outline_rounded,size: 25, color: Colors.white,)
    );
    }

    static void successSnack({required String title, required String message,}){
    Get.snackbar(
      title, message,
      colorText: Colors.white,
      backgroundColor: Colors.green,
      mainButton: TextButton(
        onPressed: () => Get.back(), 
        child: Text(
          'Close',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600
          ),
        )
      ),          
      snackPosition: SnackPosition.BOTTOM,
      animationDuration: Duration(seconds: 5),
      icon: Icon(Icons.check_circle_outline_rounded,size: 25, color: Colors.white,)
    );
    }

    static void infoSnack({required String title, required String message,}){
    Get.snackbar(
      title, message,
      colorText: Colors.white,
      backgroundColor: Colors.blue,
      mainButton: TextButton(
        onPressed: () => Get.back(), 
        child: Text(
          'Close',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600
          ),
        )
      ),          
      snackPosition: SnackPosition.BOTTOM,
      animationDuration: Duration(seconds: 5),
      icon: Icon(Icons.info_outline_rounded,size: 25, color: Colors.white,)
    );
    }
  }


