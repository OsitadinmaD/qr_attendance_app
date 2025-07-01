import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/sign_up/widgets/snackbar_message_show.dart';
import 'package:uuid/uuid.dart';

import '../../../../lecturer_screen/home/pages/my_sessions/session model/session_model.dart';

class ActiveSessionsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser?.uid;
  // generate random id for participant
  final _participantId = Uuid().v4();

  //fetch events with open join window
  Stream<List<SessionModel>> fetchActiveSessions(){
    return _firestore
      .collection('sessions')
      .where('joinEndTime', isGreaterThan: Timestamp.now())
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => SessionModel.fromFirestore(doc))
          .where((session) => session.isJoinWindowOpen).toList());
  }

  Stream<List<SessionModel>> getJoinedSessions(){
    if (userId == null) return const Stream.empty();

    return _firestore
      .collection('participants')
      .where('studentId', isEqualTo: userId)
      .snapshots()
      .asyncMap((snapshot) async {
        final sessionIds = snapshot.docs.map((doc) => doc['sessionId'] as String).toList(); 

        if(sessionIds.isEmpty) return [];

        final sessionsShot = await _firestore
          .collection('sessions')
          .where(FieldPath.documentId, whereIn: sessionIds)
          .get();

        return sessionsShot.docs.map((doc)=>SessionModel.fromFirestore(doc)).toList() ;
      });
  }

  //join a session
  Future<void> joinSession({required String sessionId,}) async {
    try {
      final String userId = FirebaseAuth.instance.currentUser!.uid;
      final userDoc = await FirebaseFirestore.instance
        .collection('usersData')
        .doc(userId)
        .get();
      
      if(!userDoc.exists) throw Exception('User data not found');

      final userData = userDoc.data()!;
      final participantDocId = '${sessionId}_$userId';

      await _firestore
        .collection('participants')
        .doc(participantDocId)
        .set({
          'participantId': _participantId ,
          'sessionId': sessionId,
          'studentId': userId,
          'studentName': userData['name'],
          'studentIdNumber': userData['idNumber'] ,
          'department': userData['department'],
          'joinedAt': FieldValue.serverTimestamp(),
          'attendanceMarked': false
        }).whenComplete(() => snackBarshow(
          title: 'Success', 
          message: 'You have successfully joined the session', 
          backgroundColor: Colors.green, 
          icon: Icons.check_circle_outline_rounded
        ),
      );
    } catch (e) {
      snackBarshow(
        title: 'Error', 
        message: 'An unexpected error occurred', 
        backgroundColor: Colors.red, 
        icon: Icons.error_outline_rounded
      );
    }
  }
}