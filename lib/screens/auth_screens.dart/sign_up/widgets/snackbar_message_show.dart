import 'package:flutter/material.dart';
import 'package:get/get.dart';

void snackBarshow({required String title, required String message, required Color backgroundColor,required IconData icon}){
    Get.snackbar(
      title, message,
      colorText: Colors.white,
      backgroundColor: backgroundColor,
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
      snackPosition: SnackPosition.TOP,
      animationDuration: Duration(seconds: 5),
      icon: Icon(icon,size: 25, color: Colors.white,)
    );
  }