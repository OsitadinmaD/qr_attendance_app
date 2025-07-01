import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/pages/my_sessions/session%20model/session_model.dart';

import '../controller/attendance_record_controller.dart';
import '../controller/participants_controller.dart';
import '../participant model/participant_model.dart';

class AttendanceParticipantsScreens {
   final sessionAttendanceController = Get.put<AttendanceRecordController>(AttendanceRecordController());

  Widget buildAttendanceScreen(SessionModel session) {
    sessionAttendanceController.loadAttendance(session.sessionId);
    return Column(
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
  
  final sessionParticipantsController = Get.put<ParticipantsController>(ParticipantsController());
  Widget buildParticipantScreen(SessionModel session) {
    return Column(
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
        Expanded(
          child: StreamBuilder<List<ParticipantModel>>(
            stream: sessionParticipantsController.loadParticipantsStream(session.sessionId), 
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(color: Colors.white,));
              }
              if(snapshot.hasError){
                return Center(
                  child: Text(
                    'An Error Occurred',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                );
              }
              if (!snapshot.hasData){
                return Center(
                  child: ClipRRect(
                    child: Image.asset('assets/in_app_images/empty.png',fit: BoxFit.cover,),
                  ),
                );
              }
              // Update controller state
              sessionParticipantsController.participants.value = snapshot.data!;
              return sessionParticipantsController.buildParticipantList();
            },
          )
        )
      ],
    );
  }


}
