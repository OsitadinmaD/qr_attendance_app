import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/pages/my_sessions/model/session_model.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/sign_up/widgets/snackbar_message_show.dart';

class SessionsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //List to store sessions from firestore
  RxList<SessionModel> allSessions = <SessionModel>[].obs;
  RxList<SessionModel> activeSessions = <SessionModel>[].obs;

  //Fetch all the sessions the lecturers have created
  Future<void> fetchLecturerSessions(String lecturerId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
      .collection('sessions')
      .where('lecturerId', isEqualTo: lecturerId)
      .orderBy('createdAt', descending: true)
      .get();

      allSessions.assignAll(
        querySnapshot.docs.map((doc) => SessionModel.fromFirestore(doc)).toList()
      );
    } catch (e) {
      snackBarshow(
        title: 'Error', 
        message: 'Failed to fetch all events: ${e.toString()}', 
        backgroundColor: Colors.red,
        icon: Icons.error_outline_rounded
      );
    }
  }

  Future<void> fetchActiveEvents() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
      .collection('sessions')
      .where('joinEndTime', isGreaterThan: Timestamp.now())
      .orderBy('joinEndTime', descending: false)
      .get();

      activeSessions.assignAll(
        querySnapshot.docs.map((doc) => SessionModel.fromFirestore(doc)).toList(),
      );
    } catch (e) {
      snackBarshow(
        title: 'Error', 
        message: 'Failed to fetch active events: ${e.toString()}', 
        backgroundColor: Colors.red,
        icon: Icons.error_outline_rounded
      );
    }
  }

  //Read lecturers events as streams
  Stream<List<SessionModel>> getLecturerSessionStream(String lecturerId){
    return _firestore
    .collection('sessions')
    .where('lecturerId', isEqualTo: lecturerId)
    .orderBy('createdAt', descending: true)
    .snapshots()
    .map((snapshot) => snapshot.docs
      .map((doc) => SessionModel.fromFirestore(doc)).toList());
  }

  //Lecturer's sessions UI
  


}