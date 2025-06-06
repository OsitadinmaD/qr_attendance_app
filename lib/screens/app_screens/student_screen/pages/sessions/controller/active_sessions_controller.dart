import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/pages/my_sessions/model/session_model.dart';

class ActiveSessionsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser?.uid;
  //final RxList<SessionModel> activeSessions = <SessionModel>[].obs;

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
  Future<void> joinSession(String sessionId) async {
    if (userId == null) return;

    await _firestore
      .collection('participants')
      .doc('${sessionId}_$userId')
      .set({
        'sessionId': sessionId,
        'studentId': userId,
        'joinedAt': FieldValue.serverTimestamp(),
        'attendanceMarked': false
      });
  }
}