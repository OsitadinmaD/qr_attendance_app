
import 'package:cloud_firestore/cloud_firestore.dart';

class SessionModel {
  const SessionModel({
    required this.sessionId,
    required this.lecturerId,
    required this.title,
    required this.description,
    required this.department,
    required this.joinStartTime,
    required this.joinEndTime,
    required this.qrCodeData,
    required this.isQRActive,
    required this.createdAt,
  });

  final String sessionId, lecturerId, title, description,department, qrCodeData;
  final bool isQRActive;
  final DateTime createdAt, joinEndTime, joinStartTime;

  //convert firestore document to session document 
  factory SessionModel.fromFirestore(DocumentSnapshot doc){
    Map<String, dynamic> session = doc.data() as Map<String, dynamic>;
    return SessionModel(
      sessionId: session['sessionId'] ?? '',
      lecturerId: session['lecturerId'] ?? '',
      title: session['title'] ?? '', 
      description: session['description'] ?? '', 
      department: session['department'] ?? '', 
      joinStartTime: (session['joinStartTime'] as Timestamp).toDate(), 
      joinEndTime: (session['joinEndTime'] as Timestamp).toDate(), 
      qrCodeData: session['qrCodeData'] ?? '',
      isQRActive: session['isQRActive'] ?? false,
      createdAt: (session['createdAt']as Timestamp).toDate(),
    );
  }

  bool get isJoinWindowOpen {
    final now = DateTime.now();
    return now.isAfter(joinStartTime) && now.isBefore(joinEndTime);
  }

}