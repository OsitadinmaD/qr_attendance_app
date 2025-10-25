import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/pages/my_sessions/session%20model/session_model.dart';

import '../controller/attendance_record_controller.dart';
import '../controller/participants_controller.dart';

class AttendanceParticipantsScreens {

  Widget buildAttendanceScreen(SessionModel session) {
   final AttendeesController lecturerController = Get.put(AttendeesController());

   lecturerController.fetchSessionAttendance(session.id);

    return Column(
      children: [
        buildAttendeesStat(session),
        //search bar
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: lecturerController.searchController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Search participants',
              prefixIcon: Icon(Icons.search_rounded, color: Colors.black,)
            ),
            onChanged: (value) {
              lecturerController.searchQuery.value = value;
            },
          ),
        ),

        Obx(() {
            if (lecturerController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
        
            if (lecturerController.sessionAttendees.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20,),
                    const Icon(Icons.event_available_rounded, size: 64, color: Colors.grey,),
                    const SizedBox(height: 16,),
                    Text(
                     'No attendees yet',
                     style: TextStyle(
                     color: Colors.grey,
                     fontSize: 18,
                     fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 8,),
                  Text(
                    'Attendees will be seen here',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                    ),
                  )
                ],
              ),
             );
            }
        
            return Expanded(
              child: lecturerController.searchQuery.isEmpty ? 
              ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: lecturerController.sessionAttendees.length,
                itemBuilder: (context, index) {
                  final attendee = lecturerController.sessionAttendees[index];
                  return  _buildAttendanceTile(participant: attendee, context: context);
                },
              ) :
              ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: lecturerController.filteredAttendees.length,
                itemBuilder: (context, index) {
                  final attendee = lecturerController.filteredAttendees[index];
                  return  _buildAttendanceTile(participant: attendee, context: context);
                },
              ),
            );
          }
        ),
      ],
    );
  }

  //build attendance stat
  Widget buildAttendeesStat(SessionModel session){
    final controller = Get.put<AttendeesController>(AttendeesController());
    final participantController = Get.put(ParticipantsController(sessionId: session.id));
    return Obx((){

      return Card(
        margin: EdgeInsets.all(16),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard('Total', '${participantController.totalPartcicipants.value}'),
              _buildStatCard('Present', '${controller.sessionAttendees.length}'),
              _buildStatCard('Absent', '${participantController.totalPartcicipants.value - controller.sessionAttendees.length}'),
            ],
          ),
        ),
      );
    });
  }

  //build participant tile
  Widget _buildAttendanceTile({required AttendanceViewModel participant, required BuildContext context}){
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Icon(
              Icons.person, 
              color: Theme.of(context).colorScheme.primary,
              size: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participant.studentName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(0, 0, 0, 1),
                    fontSize: 15
                  ),
                ),
                Text(
                  'ID: ${participant.matricNumber}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(0, 0, 0, 1),
                    fontSize: 12
                  ),
                ),
                Text(
                  'Department: ${participant.department}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(0, 0, 0, 1),
                    fontSize: 12
                  ),
                ),
                Text(
                  //will be corected
                  'Recorded at: ${DateFormat.MMMd().add_jm().format(participant.timestamp)}',// Update from firestore
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(0, 0, 0, 1),
                    fontSize: 12
                  ),
                ),
                Chip(
                  color: WidgetStateProperty.all(Colors.green.shade300),//update this from the participant collection
                  label: Text(
                    'Attendance taken successfully',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12
                    ),
                  ),
                ) 
              ],
            )
            
          ],
        ),
      )
    );
  }

  Widget _buildStatCard(String title, String value){
    return Column(
      spacing: 4,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
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
