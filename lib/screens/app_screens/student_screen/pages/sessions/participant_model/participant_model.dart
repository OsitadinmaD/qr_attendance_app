import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Participant {
  final String sessionId, studentId, sessionDescription;
  final String sessionTitle, qrData;
  final bool attendanceMarked;
  final DateTime? joinedAt;

  const Participant({
    required this.sessionId,
    required this.studentId,
    required this.joinedAt,
    required this.sessionTitle,
    required this.qrData,
    required this.attendanceMarked,
    required this.sessionDescription,
  });

  factory Participant.fromFirebaseDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Participant(
      sessionId: data['sessionId'] ?? '' , 
      studentId: data['studentId'] ?? userId, 
      joinedAt: (data['joinedAt'] as Timestamp?)?.toDate(), 
      sessionTitle: data['sessionTitle'] ?? '', 
      qrData: data['qrData'] ?? '',
      attendanceMarked: data['attendanceMarked'] ?? false, 
      sessionDescription: data['sessionDescription'] ?? '', 
    );
  }
}