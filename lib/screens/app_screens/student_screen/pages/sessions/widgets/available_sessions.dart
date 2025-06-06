import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/pages/my_sessions/model/session_model.dart';
import 'package:qr_attendance_app/screens/app_screens/student_screen/pages/sessions/controller/active_sessions_controller.dart';

class AvailableSessions {
  AvailableSessions();

  Widget buildActiveSessionStream(){
    final controller = Get.put<ActiveSessionsController>(ActiveSessionsController());
    return StreamBuilder<List<SessionModel>>(
      stream: controller.fetchActiveSessions(), 
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(color: Colors.blue,),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              spacing: 5,
              children: [
                ClipRRect(
                  child: Image.asset(
                    'assets/in_app_images/empty.png',
                    height: Get.height * 0.6,
                    width: Get.width * 0.8,
                  ),
                ),
                
                Text(
                  'No active sessions available',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          //shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: snapshot.data!.length ,
          itemBuilder: (context, index) {
            final session = snapshot.data![index];

            return _buildSessionCard(session, isActive: true);
          },

        );
      },
    );
  }

  Widget buildJoinedSessionsStream(){
    final controller = Get.put<ActiveSessionsController>(ActiveSessionsController());
    return StreamBuilder<List<SessionModel>>(
      stream: controller.getJoinedSessions(), 
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(color: Colors.blue,),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              //spacing: 1,
              children: [
                ClipRRect(
                  child: Image.asset(
                    'assets/in_app_images/empty.png',
                    height: Get.height * 0.6,
                    width: Get.width * 0.7,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          //shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: snapshot.data!.length + 1,
          itemBuilder: (context, index) {
            final session = snapshot.data![index];
            
            return _buildSessionCard(session, isActive: false);
          },
        );
      },
    );
  }

  Widget _buildSessionCard(SessionModel session, {required bool isActive})  {
    final remainingTime = session.joinEndTime.difference(DateTime.now());
    final hoursLeft = remainingTime.inHours;
    final minutesLeft = remainingTime.inMinutes;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              session.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 8,),
            Text(
              session.description,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 12,),
            Row(
              children: [
                Icon(Icons.access_time_rounded, size: 16,),
                const SizedBox(width: 4,),
                Text(
                  'Closes in $hoursLeft hours $minutesLeft minutes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16,),
            if(isActive) _buildJoinButton(session),
            if(!isActive) _buildJoinedStatus(),
          ],
        ),
      ),
    );
  }

  Widget _buildJoinButton(SessionModel session){
    final controller = Get.put<ActiveSessionsController>(ActiveSessionsController());
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
        .collection('participants')
        .doc('${session.sessionId}_${controller.userId}')
        .snapshots(), 
      builder: (context, snapshot) {
        final hasJoined = snapshot.hasData && snapshot.data!.exists;

        return ElevatedButton(
          onPressed: hasJoined ? null : () => controller.joinSession(session.sessionId), 
          style: ElevatedButton.styleFrom(
            backgroundColor: hasJoined ? Colors.grey : Colors.blue 
          ),
          child: Text(
            hasJoined ? 'Joined' : 'Join Session',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white
            ),
          ),
        );
      },
    );
  }

  Widget _buildJoinedStatus(){
    return Row(
      children: [
        Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 16,),
        Text(
          'You\'ve joined this session',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.green
          ),
        ),
      ],
    );
  }
}