import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/pages/my_sessions/sub_pages/participant%20model/participant_model.dart';

class AttendanceRecordModel {
  final String? id;
  final String sessionId;
  final String studentId;
  final String studentName;
  final String studentIdNumber;
  final bool attendanceMarked;
  final DateTime? markedAt;

  const AttendanceRecordModel({this.id,required this.sessionId,required this.studentId,required this.studentName,
    required this.studentIdNumber,required this.attendanceMarked, this.markedAt});

  factory AttendanceRecordModel.fromFirestore(DocumentSnapshot doc){
    final data = doc.data() as Map<String, dynamic>;
    
    return AttendanceRecordModel(
      id: doc.id, 
      sessionId: data['sessionId'], 
      studentId: data['studentId'], 
      studentName: data['studentName'], 
      studentIdNumber: data['studentIdNumber'], 
      attendanceMarked: data['attendanceMarked'] ?? false, 
      markedAt: data['markedAt']?.toDate(),
    );
  } 

  factory AttendanceRecordModel.empty(ParticipantModel participant){
    return AttendanceRecordModel(
      sessionId: participant.sessionId, 
      studentId: participant.studentId, 
      studentName: participant.studentName, 
      studentIdNumber: participant.studentIdNumber, 
      attendanceMarked: false, 
    );
  }

}