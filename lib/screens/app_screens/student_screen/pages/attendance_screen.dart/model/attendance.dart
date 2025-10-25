import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  final String sessionId;
  final String studentId, sessionName;
  final DateTime timestamp;
  final String studentName;
  final String studentIdNumber;
  final String department;
  final String qrCodeUsed;
  final String biometricVerified;
  final String status;

  Attendance({
    required this.sessionId,
    required this.studentId,
    required this.sessionName,
    required this.timestamp,
    required this.studentName,
    required this.studentIdNumber,
    required this.department,
    required this.qrCodeUsed,
    required this.biometricVerified,
    this.status = 'present',
  });

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'sessionId': sessionId,
      'sessionName': sessionName,
      'studentName': studentName,
      'studentIdNumber': studentIdNumber,
      'department': department,
      'qrCodeUsed': qrCodeUsed,
      'biometricVerified': biometricVerified,
      'status': 'present',
      'timestamp': timestamp,
    };
  }

  factory Attendance.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return Attendance(
      sessionId: map['sessionId'],
      sessionName: map['sessionName'],
      studentId: map['studentId'],
      studentName: map['studentName'],
      studentIdNumber: map['studentIdNumber'],
      department: map['department'],
      qrCodeUsed: map['qrCodeUsed'],
      biometricVerified: map['biometricVerified'],
      status: map['status'] ?? 'present',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
  