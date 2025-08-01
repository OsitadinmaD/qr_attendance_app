import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/pages/my_sessions/session%20model/session_model.dart';

import '../controller/attendance_record_controller.dart';
import '../controller/participants_controller.dart';

class AttendanceParticipantsScreens {
   final sessionAttendanceController = Get.put<AttendanceRecordController>(AttendanceRecordController());

  Widget buildAttendanceScreen(SessionModel session) {
    sessionAttendanceController.loadAttendance(session.id);
    return sessionAttendanceController.isLoading.value ? 
      Center(child: CircularProgressIndicator(color: Colors.blue,),) :
      Column(
      children: [
        sessionAttendanceController.buildAttendanceStat(),
        //search bar
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: sessionAttendanceController.searchController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Search Student',
              prefixIcon: Icon(Icons.search_rounded, color: Colors.black,)
            ),
            onChanged: (value) {
              sessionAttendanceController.searchQuery.value = value;
            },
          ),
        ),
        sessionAttendanceController.buildAttendanceList(),
      ],
    );
  }
  

  Widget buildParticipantScreen(SessionModel session) {
    final sessionParticipantsController = Get.put<ParticipantsController>(ParticipantsController(sessionId: session.id));
    return sessionParticipantsController.isLoading.value ?
      Center(child: CircularProgressIndicator(color: Colors.blue,)) :
     Column(
      children: [
        sessionParticipantsController.buildAttendanceStat(),
        //search bar
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: sessionParticipantsController.searchController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Search participants',
              prefixIcon: Icon(Icons.search_rounded, color: Colors.black,)
            ),
            onChanged: (value) {
              sessionParticipantsController.searchQuery.value = value;
            },
          ),
        ),
        
        sessionParticipantsController.buildParticipantList()
      ],
    );
  }
}
