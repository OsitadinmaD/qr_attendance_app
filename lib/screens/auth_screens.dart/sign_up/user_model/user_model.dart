import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String idNumber;
  final String email;
  final String name;
  final String role;
  final String department;
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.idNumber,
    required this.email,
    required this.name,
    required this.role,
    required this.department,
    required this.createdAt
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data){
    return UserModel(
      userId: data['userId'] ?? '', 
      idNumber: data['idNumber'] ?? 'Unknown', 
      email: data['email'] ?? '', 
      name: data['name'] ?? '', 
      role: data['name'] ?? 'Student', 
      department: data['department'],
      createdAt: (data['createdAt'] as Timestamp).toDate()
    );
  }
}