import 'package:cloud_firestore/cloud_firestore.dart';
class AttendanceRecord {
  final String id;
  final String eventId;
  final String studentId;
  final String studentName;
  final String studentIdNumber;
  final String department;
  final DateTime timestamp;
  final bool biometricVerified;

  AttendanceRecord({
    required this.id,
    required this.eventId,
    required this.studentId,
    required this.studentName,
    required this.studentIdNumber,
    required this.department,
    required this.timestamp,
    required this.biometricVerified 
  });

  factory AttendanceRecord.fromFirestore(DocumentSnapshot doc){
    final data = doc.data() as Map<String, dynamic>;

    return AttendanceRecord(
      id: doc.id, 
      eventId: data['eventId'], 
      studentId: data['studentId'], 
      studentName: data['studentName'], 
      studentIdNumber: data['studentIdNumber'], 
      department: data['department'], 
      timestamp: (data['timestamp'] as Timestamp).toDate(), 
      biometricVerified: data['biometricVerified']
    );
  }
}