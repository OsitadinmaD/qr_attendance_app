// ignore_for_file: avoid_print

import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_auth/local_auth.dart';
import 'package:qr_attendance_app/constants/helpers/snackbar_message_show.dart';
import '../../attendance_screen.dart/model/attendance.dart';

//import '../../../../../../util/permissions_service.dart'; 

class AttendanceController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalAuthentication _auth = LocalAuthentication();
  //final PermissionService _permissionService = PermissionService();
  late ConfettiController confettiController;
  

  // Reactive variables for UI states
  RxList<Attendance> studentAttendanceHistory = <Attendance>[].obs;
  RxMap<String, List<Attendance>> groupedAttendance = <String, List<Attendance>>{}.obs;
  RxBool isLoading = false.obs;
  
  RxString message = ''.obs; // For displaying success/error messages
  RxBool isAttendanceSuccess = false.obs; // To track if attendance was successfully marked

  @override
  void onInit() {
    super.onInit();
    confettiController = ConfettiController(duration: const Duration(seconds: 3));
    ever(isAttendanceSuccess, (bool isSuccess) {
      if (isSuccess) {
        confettiController.play();
      } 
    });
  }

  


  // --- Core Logic for Attendance Marking ---
  Future<void> markAttendance({
    required String qrCodeData,
    required String currentSessionId, // The session the user is currently in
  }) async {
    isLoading.value = true;
    isAttendanceSuccess.value = false;

    message.value = 'Processing attendance...';
    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      // 1. Validate QR Code Data & Get Participant Info from Firestore
      final participantSnapshot = await _firestore
          .collection('participants')
          .where('qrData', isEqualTo: qrCodeData)
          .limit(1)
          .get();

      if (participantSnapshot.docs.isEmpty) {
        message.value = 'Error: Invalid QR Code Data. Participant not found.';
        SnackbarMessageShow.errorSnack(title: 'Attendance Failed',message: message.value,);
        return;
      }

      final participantData = participantSnapshot.docs.first.data();
      final String studentId = participantData['studentId'];
      final String participantSessionId = participantData['sessionId'];

      // 2. Validate Session Match
      if (participantSessionId != currentSessionId) {
        message.value = 'Error: QR code is for a different session.';
        SnackbarMessageShow.errorSnack(title: 'Attendance Failed',message: message.value,);
        return;
      }


      // 3. Check if Student Already Marked Present for this Session
      final existingAttendance = await _firestore
          .collection('attendance')
          .where('studentId', isEqualTo: studentId)
          .where('sessionId', isEqualTo: currentSessionId)
          .where('status', isEqualTo: 'present')
          .limit(1)
          .get();

      if (existingAttendance.docs.isNotEmpty) {
        message.value = 'You have already marked attendance for this session.';
        SnackbarMessageShow.infoSnack(title: 'Attendance Info', message: message.value,);
        return;
      }

      // 4. Perform Biometric Authentication
      bool authenticated = await _authenticateBiometrics();

      String biometricStatus = authenticated ? 'success' : 'failed';
      if (!authenticated) {
        message.value = 'Biometric authentication failed or canceled.';
        SnackbarMessageShow.errorSnack(title: 'Authentication Failed',message: message.value, );
        return;
      }

      final userDoc = await FirebaseFirestore.instance
      .collection('usersData')
      .doc(userId)
      .get();

      final sessionName = participantData['sessionTitle'] ?? 'Unknown Session';

      if (!userDoc.exists) throw Exception('User data not found');

      final userData = userDoc.data()!;

      // 5. Mark Attendance in Firestore
      await _firestore.collection('attendance').add({
        'studentId': studentId,
        'sessionId': currentSessionId,
        'sessionName': sessionName,
        'studentName': userData['name'],
        'studentIdNumber': userData['idNumber'],
        'department': userData['department'],
        'timestamp': FieldValue.serverTimestamp(), // Use server timestamp for accuracy
        'qrCodeUsed': qrCodeData,
        'biometricVerified': biometricStatus,
        'status': 'present',
      }).whenComplete((){
        message.value = 'Attendance marked successfully!';
        SnackbarMessageShow.successSnack(title: 'Success',message: message.value,);
      });

      //find the participant document using unique qrCode data
      isAttendanceSuccess.value = true;

      await FirebaseFirestore.instance
        .collection('participants')
        .doc(participantSnapshot.docs.first.id)
        .update({'attendanceMarked': true});

    } catch (e) {
      message.value = 'An unexpected error occurred: ${e.toString()}';
      SnackbarMessageShow.errorSnack(title: 'Error',message: message.value,);
    } finally {
      isLoading.value = false;
    }
  }

  // --- Biometric Authentication Method ---
  Future<bool> _authenticateBiometrics() async {
    try {
      bool canCheckBiometrics = await _auth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        message.value = 'Biometrics not available on this device.';
        SnackbarMessageShow.errorSnack(title:'Biometrics Error', message: message.value,);
        return false;
      }

      List<BiometricType> availableBiometrics = await _auth.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        message.value = 'No biometrics enrolled. Please set up fingerprint/face ID.';
        SnackbarMessageShow.infoSnack(title: 'Biometrics Setup',message: message.value,);
        return false;
      }

      final authenticated = await _auth.authenticate(
        localizedReason: 'Please authenticate to mark your attendance',
        options: const AuthenticationOptions(
          stickyAuth: true, // Keep the prompt visible until successful or explicitly cancelled
          biometricOnly: true, // Only allow biometrics, no PIN/pattern fallback
        ),
      );
      return authenticated;
    } catch (e) {
      print('Biometric authentication error: $e');
      message.value = 'Error during biometric authentication: ${e.toString()}';
      SnackbarMessageShow.errorSnack(title: 'Biometrics Error',message: message.value,);
      return false;
    }
  }
  @override
  void onClose() {
    //confettiController.dispose();
    super.onClose();
  }
}

