// ignore_for_file: invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/constants/helpers/snackbar_message_show.dart';
import 'package:qr_attendance_app/screens/app_screens/student_screen/pages/sessions/participant_model/participant_model.dart';

import '../../../../lecturer_screen/home/pages/my_sessions/session model/session_model.dart';

class ActiveSessionsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser?.uid;
  final RxList<SessionModel> joinedSessions = <SessionModel>[].obs;
  final RxMap<String, bool> joinedStatus = <String, bool>{}.obs; 
  //final RxBool isLoadingJoinedSessions = true.obs;

  @override
  void onInit() {
    super.onInit();
    getJoinedSessions();
    fetchActiveSessions();
  }

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

  checkIfJoined(String sessionId, String studentId) async {
    try {
      final joined = await _firestore.collection('participants')
      .where('sessionId',isEqualTo: sessionId)
      .where('studentId', isEqualTo: studentId)
      .limit(1)
      .get();

      joinedStatus[sessionId] = joined.docs.isNotEmpty;
    } catch (e) {
      joinedStatus[sessionId] = false;
      // ignore: avoid_print
      print('Error getting document: $e');
    }
  }

  
  Stream<List<Participant>> getJoinedSessions() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return _firestore
    .collection('participants')
    .where('studentId', isEqualTo: userId)
    .orderBy('joinedAt', descending: true)
    .snapshots()
    .map((snapshot){ 
      // ignore: avoid_print
      print('Snapshot size: ${snapshot.docs.length}');
      return snapshot.docs.map((doc){
        try {
          return Participant.fromFirebaseDoc(doc);
        } catch (e) {
          // ignore: avoid_print
          printError(info: 'Mapping error: $e');
        }
      }).whereType<Participant>().toList();
    });
  }

  //join a session
  Future<void> joinSession({required SessionModel session}) async {
    try {
      final String userId = FirebaseAuth.instance.currentUser!.uid;
      final userDoc = await FirebaseFirestore.instance
        .collection('usersData')
        .doc(userId)
        .get();
      
      if(!userDoc.exists) throw Exception('User data not found');

      
          await _firestore
          .collection('participants')
          .add({
            'sessionId': session.id,
            'studentId': userId,
            'joinedAt': FieldValue.serverTimestamp(),
            'attendanceMarked': false,
            'qrData': session.qrCodeData,
            'sessionTitle': session.title,
            'sessionDescription': session.description,
          }).whenComplete(() => SnackbarMessageShow.successSnack(
            title: 'Success', 
            message: 'You have successfully joined the session',
          ),
        );
        joinedStatus[session.id] = true;
      
    } catch (e) {
      SnackbarMessageShow.errorSnack(
        title: 'Error', 
        message: 'An unexpected error occurred', 
      );
    }
  }
}