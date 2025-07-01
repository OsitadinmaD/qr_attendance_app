import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/pages/my_sessions/sub_pages/participant%20model/participant_model.dart';

class ParticipantsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<ParticipantModel> participants = <ParticipantModel>[].obs;
  final searchController = TextEditingController();
  RxString searchQuery = ''.obs;



  //set current session and fetch participant
  Stream<List<ParticipantModel>> loadParticipantsStream(String sessionId){
    return _firestore
      .collection('participants')
      .where('sessionId', isEqualTo: sessionId)
      .orderBy('joinedAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
        .map((doc) => ParticipantModel.fromFirestore(doc))
        .toList());
  }

  //Get filtered participants based on search
  List<ParticipantModel> get filteredParticipants {
    if (searchQuery.value.isEmpty) return participants;

    return participants.where((participant) {
      return participant.studentName.toLowerCase().contains(searchQuery.value) ||
        participant.studentIdNumber.toLowerCase().contains(searchQuery.value);
    }).toList();
  }

  void bindParticipantStream(String sessionId){
    //clear existing participants
    participants.clear();

    //Bind to the stream
    ever<String>(searchQuery, (_) => loadParticipantsStream(sessionId),cancelOnError: true);
  }

  //build attendance stat
  Widget buildAttendanceStat(){
    return Obx((){
      final total = participants.length;
      final present = participants.where((participant) => participant.attendanceMarked).length;

      return Card(
        margin: EdgeInsets.all(16),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard('Total', '$total'),
              _buildStatCard('Present', '$present'),
              _buildStatCard('Absent', '${total - present}'),
            ],
          ),
        ),
      );
    });
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

  //build participants list
  Widget buildParticipantList(){
    return Obx((){
      final participants  = filteredParticipants;

      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: participants.length,
        itemBuilder: (context, index) {
          final participant = participants[index];
          
          return _buildParticipantTile(participant);
        },
      );
    }

    );
  }

  //build participant tile
  Widget _buildParticipantTile(ParticipantModel participant){
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey,
          child: Text(
            participant.studentName[0]
          ),
        ),
        title: Text(
          participant.studentName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20
          ),
        ),
        subtitle: Column(
          children: [
            Text(
              'ID: ${participant.studentIdNumber}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 16
              ),
            ),
            Text(
              'Department: ${participant.department}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 16
              ),
            ),
            Text(
              'Joined at: ${DateFormat.MMMd().add_jm().format(participant.joinedAt)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16
              ),
            ),
          ],
        ),
        trailing: participant.attendanceMarked ?
          Chip(
            color: WidgetStateProperty.all(Colors.green),
            label: Text(
              'Present',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16
              ),
            ),
          ) : 
          Chip(
            color: WidgetStateProperty.all(Colors.red),
            label: Text(
              'Absent',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16
              ),
            ),
          ) 
      ),
    );
  }

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
  }
}