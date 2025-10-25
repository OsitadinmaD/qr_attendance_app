import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/constants/helpers/snackbar_message_show.dart';
import 'package:qr_attendance_app/screens/app_screens/student_screen/pages/attendance_screen.dart/model/attendance.dart';

class FetchStudentAttendance extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxBool isLoading = false.obs;
  RxList<Attendance> classes = <Attendance>[].obs;

  Future<void> fetchStudentAttendance() async {
    isLoading.value = true;

    final String? studentId = FirebaseAuth.instance.currentUser?.uid;

    if (studentId == null) {
      printError(info: 'No authenticated user found');
      isLoading.value = false;
      return;
    }

    try {
      final attendanceSnapshot = await _firestore
        .collection('attendance')
        .where('studentId', isEqualTo: studentId)
        .orderBy('timestamp', descending: true)
        .get();

        classes.value = attendanceSnapshot.docs.map((doc) => Attendance.fromFirestore(doc)).toList();
    } catch (e) {
      printError(info: 'Error fetching student data: $e');
      SnackbarMessageShow.errorSnack(title: 'Error', message: 'Error fetching student data');
    } finally {
      isLoading.value = false;
    }
  }
}