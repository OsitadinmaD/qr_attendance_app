import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String uid;
  final String email;
  final bool isLecturer;
  final String name;

  AppUser({
    required this.uid,
    required this.email,
    required this.isLecturer,
    required this.name
  });

  factory AppUser.fromFirebaseUser(User user, Map<String, dynamic> data){
    return AppUser(
      uid: user.uid, 
      email: user.email ?? '', 
      isLecturer: data['isLecturer'] ?? false , 
      name: data['name'] ?? 'User'
    );
  }
}