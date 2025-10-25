// lib/controllers/lecturer_controller.dart

import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_saver/file_saver.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../../../constants/helpers/snackbar_message_show.dart';

class AttendanceViewModel {
  final String studentId;
  final String studentName;
  final String matricNumber;
  final String department;
  final DateTime timestamp;

  AttendanceViewModel({
    required this.studentId,
    required this.studentName,
    required this.matricNumber,
    required this.department,
    required this.timestamp,
  });
}

class AttendeesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;
  RxBool isDownloading = false.obs;
  RxString message = ''.obs;
  RxList<AttendanceViewModel> sessionAttendees = <AttendanceViewModel>[].obs;
  RxList<AttendanceViewModel> filteredAttendees = <AttendanceViewModel>[].obs;
  RxString searchQuery = ''.obs;
  late TextEditingController searchController;

  @override
  void onInit() {
    super.onInit();
    ever(searchQuery,(_) => _filterAttendees());
    searchController = TextEditingController();
  }

  @override
  void onClose(){
    searchController.dispose();
  }


  void _filterAttendees(){
    if(searchQuery.value.isEmpty){
      filteredAttendees.value = sessionAttendees;
    } else {
      filteredAttendees.value = sessionAttendees.where((attendee){
        return attendee.studentName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          attendee.matricNumber.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }

    
  }

  Future<void> fetchSessionAttendance(String sessionId) async {
    isLoading.value = true;
    message.value = 'Fetching attendance...';
    sessionAttendees.clear();

    try {
      // 1. Fetch attendance records for the given session ID
      final attendanceSnapshot = await _firestore
          .collection('attendance')
          .where('sessionId', isEqualTo: sessionId)
          .orderBy('timestamp', descending: false)
          .get();

      if (attendanceSnapshot.docs.isEmpty) {
        message.value = 'No attendees found for this session.';
        isLoading.value = false;
        return;
      }

      final List<String> studentIds = attendanceSnapshot.docs.map((doc) => doc['studentId'] as String).toList();
      
      // 2. Fetch student profiles to get names and matric numbers
      final usersSnapshot = await _firestore.collection('usersData')
          .where(FieldPath.documentId, whereIn: studentIds)
          .get();

      final Map<String, dynamic> usersData = {};
      for(var doc in usersSnapshot.docs){
        usersData[doc.id] = doc.data();
      }

      // 3. Combine the data into a view model
      final List<AttendanceViewModel> attendees = attendanceSnapshot.docs.map((attendanceDoc) {
        final attendanceData = attendanceDoc.data();
        final String studentId = attendanceData['studentId'];
        final userData = usersData[studentId];

        return AttendanceViewModel(
          studentId: studentId,
          studentName: userData?['name'] ?? 'N/A',
          matricNumber: userData?['idNumber'] ?? 'N/A',
          department: userData?['department'] ?? 'N/A',
          timestamp: attendanceData['timestamp'] != null
              ? attendanceData['timestamp'].toDate()
              : 'N/A',
        );
      }).toList();

      sessionAttendees.value = attendees;
      message.value = 'Attendance loaded successfully.';
    } catch (e) {
      message.value = 'An error occurred while fetching attendance: ${e.toString()}';
      // ignore: avoid_print
      printError(info: 'Error fetching attendance: $e');
      Get.snackbar('Error', message.value, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadSessionAttendance(String sessionId) async {
    isDownloading.value = true;
    message.value = 'Preparing download...';

    try{
      // 1. check and request permission 
      if(GetPlatform.isAndroid){
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          message.value = 'Storage permission denied. Cannot download file';
          SnackbarMessageShow.infoSnack(title: 'Permission denied',message: message.value,);
          isDownloading.value = false;
          return;
        }
      }

      // 2. Fetch attendance data from specific session in firestore
      final attendanceSnapshot = await _firestore
        .collection('attendance')
        .where('sessionId', isEqualTo: sessionId)
        .orderBy('timestamp', descending: false)
        .get();

      if(attendanceSnapshot.docs.isEmpty){
        message.value = 'No attendance found for this session';
        SnackbarMessageShow.infoSnack(title: 'Download failed',message: message.value,);
        isDownloading.value = false;
        return;
      }

      // 3. Convert firestore data into a list of lists for csv
      final List<List<dynamic>> csvData = [
        //add header rows
        [
          'studentIdNumber','studentName','department','timestamp'
        ]
      ];

      final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

      for(var doc in attendanceSnapshot.docs){
        final data = doc.data();
        csvData.add([
          data['studentIdNumber'],
          data['studentName'],
          data['department'],
          formatter.format(data['timestamp'].toDate()),
        ]);
      }

      // 4. Convert the list of lists to a csv string 
      final csvString = const ListToCsvConverter().convert(csvData);
      final String fileName = 'attendance_session_${sessionId.replaceAll('', '_')}.csv';

      //Use file_saver to save the file 
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: Uint8List.fromList(csvString.codeUnits),
        mimeType: MimeType.csv
      );

      message.value = 'Attendance downloaded successfully';
      SnackbarMessageShow.successSnack(title: 'Success',message: message.value,);
    } catch (e){
      printError(info: 'Download failed: $e');
      message.value = 'Failed to download file: ${e.toString()}';
      SnackbarMessageShow.infoSnack(title: 'Download Error',message: message.value,);
    } finally {
      isDownloading.value = false;
    }
  }
}