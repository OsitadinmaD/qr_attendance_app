// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';

//import '../../../../../../util/permissions_service.dart'; 

class AttendanceController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalAuthentication _auth = LocalAuthentication();
  //final PermissionService _permissionService = PermissionService();

  // Reactive variables for UI states
  RxBool isLoading = false.obs;
  RxString message = ''.obs; // For displaying success/error messages

  // --- Core Logic for Attendance Marking ---
  Future<void> markAttendance({
    required String qrCodeData,
    required String currentSessionId, // The session the user is currently in
  }) async {
    isLoading.value = true;
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
        _showSnackbar('Attendance Failed', message.value, Colors.red);
        return;
      }

      final participantData = participantSnapshot.docs.first.data();
      final String studentId = participantData['studentId'];
      final String participantSessionId = participantData['sessionId'];

      // 2. Validate Session Match
      if (participantSessionId != currentSessionId) {
        message.value = 'Error: QR code is for a different session.';
        _showSnackbar('Attendance Failed', message.value, Colors.red);
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
        _showSnackbar('Attendance Info', message.value, Colors.orange);
        return;
      }

      // 4. Perform Biometric Authentication
      bool authenticated = await _authenticateBiometrics();

      String biometricStatus = authenticated ? 'success' : 'failed';
      if (!authenticated) {
        message.value = 'Biometric authentication failed or canceled.';
        _showSnackbar('Authentication Failed', message.value, Colors.red);
        return;
      }

      final userDoc = await FirebaseFirestore.instance
      .collection('usersData')
      .doc(userId)
      .get();

      if (!userDoc.exists) throw Exception('User data not found');

      final userData = userDoc.data()!;

      // 5. Mark Attendance in Firestore
      await _firestore.collection('attendance').add({
        'studentId': studentId,
        'sessionId': currentSessionId,
        'studentName': userData['name'],
        'studentIdNumber': userData['idNumber'],
        'department': userData['department'],
        'timestamp': FieldValue.serverTimestamp(), // Use server timestamp for accuracy
        'qrCodeUsed': qrCodeData,
        'biometricVerified': biometricStatus,
        'status': 'present',
      }).whenComplete((){
        message.value = 'Attendance marked successfully!';
        _showSnackbar('Success', message.value, Colors.green);
      });

      await FirebaseFirestore.instance
        .collection('participants')
        .doc('${currentSessionId}_$userId')
        .update({'attendanceMarked': true});

    } catch (e) {
      print('Error marking attendance: $e'); // Log the error for debugging
      message.value = 'An unexpected error occurred: ${e.toString()}';
      _showSnackbar('Error', message.value, Colors.red);
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
        _showSnackbar('Biometrics Error', message.value, Colors.red);
        return false;
      }

      //List<BiometricType> availableBiometrics = await _auth.getAvailableBiometrics();
      //if (availableBiometrics.isEmpty) {
        //message.value = 'No biometrics enrolled. Please set up fingerprint/face ID.';
        //_showSnackbar('Biometrics Setup', message.value, Colors.orange);
        //return false;
      //}

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
      _showSnackbar('Biometrics Error', message.value, Colors.red);
      return false;
    }
  }

  // Helper for displaying snackbars consistently
  void _showSnackbar(String title, String message, Color backgroundColor) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
    );
  }
}