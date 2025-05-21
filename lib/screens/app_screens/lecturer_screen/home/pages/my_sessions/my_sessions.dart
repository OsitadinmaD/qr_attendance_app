import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/pages/new_sessions/controller/new_session_controller.dart';

class MySessionsPage extends StatelessWidget {
  const MySessionsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mySessionsController = Get.put<NewSessionController>(NewSessionController());
    return  
        mySessionsController.getSessionsListView();
   
  }
}
