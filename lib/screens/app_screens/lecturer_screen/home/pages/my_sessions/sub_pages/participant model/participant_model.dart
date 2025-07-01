import 'package:cloud_firestore/cloud_firestore.dart';

class ParticipantModel {
  ParticipantModel({
    required this.participantId,
    required this.sessionId,
    required this.studentId,
    required this.studentName,
    required this.studentIdNumber,
    required this.department,
    required this.joinedAt,
    required this.attendanceMarked
  });

  final String participantId;
  final String sessionId;
  final String studentId;
  final String studentName;
  final String studentIdNumber;
  final String department;
  final DateTime joinedAt;
  final bool attendanceMarked;

  factory ParticipantModel.fromFirestore(DocumentSnapshot doc){
    final participantData = doc.data() as Map<String, dynamic>;

    return ParticipantModel(
      participantId: participantData['participantId'] ?? '', 
      sessionId: participantData['sessionId'] ?? '', 
      studentId: participantData['studentId'] ?? '', 
      studentName: participantData['studentName'] ?? '', 
      studentIdNumber: participantData['studentIdNumber'] ?? '', 
      department: participantData['department'] ?? '', 
      joinedAt: (participantData['joinedAt'] as Timestamp).toDate(), 
      attendanceMarked: participantData['attendanceMarked'] ?? false
    );
  }
}