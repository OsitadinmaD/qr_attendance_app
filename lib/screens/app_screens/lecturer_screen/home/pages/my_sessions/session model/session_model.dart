
import 'package:cloud_firestore/cloud_firestore.dart';

class SessionModel {
  const SessionModel({
    required this.id,
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

  final String id, lecturerId, title, description,department, qrCodeData;
  final bool isQRActive;
  final DateTime? createdAt, joinEndTime, joinStartTime;

  //convert firestore document to session document 
  factory SessionModel.fromFirestore(DocumentSnapshot doc){
    Map<String, dynamic> session = doc.data() as Map<String, dynamic>;
    return SessionModel(
      id: doc.id,
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

  factory SessionModel.placeHolder(String id){
    return SessionModel(
      id: id, 
      lecturerId: 'Loading...', 
      title: 'Loading....', 
      description: 'Loading....', 
      department: 'Loading....', 
      joinStartTime: DateTime.now(), 
      joinEndTime: DateTime.now().add(Duration(days: 1)), 
      qrCodeData: 'Loading....', 
      isQRActive: false, 
      createdAt: DateTime.now()
    );
  }

  bool get isJoinWindowOpen {
    final now = DateTime.now();
    return now.isAfter(joinStartTime!) && now.isBefore(joinEndTime!);
  }

}