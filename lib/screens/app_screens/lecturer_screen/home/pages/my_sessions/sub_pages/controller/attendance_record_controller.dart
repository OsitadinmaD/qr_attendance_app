import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../student_screen/pages/sessions/attendance_log_model.dart/attendance_model_log.dart';

class AttendanceRecordController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<AttendanceRecord> allAttendance = <AttendanceRecord>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;
  RxInt participantLength = 0.obs;
  late TextEditingController searchController;

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
  }

  List<AttendanceRecord> get filteredAttendance {
    if(searchQuery.value.isEmpty) return allAttendance;

    return allAttendance.where((record){
      return
      record.studentName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
      record.studentIdNumber.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  void loadAttendance(String sessionId){

    _firestore.collection('attendance')
    .where('sessionId', isEqualTo: sessionId)
    .orderBy('timestamp', descending: true)
    .snapshots()
    .listen((snapshot){
      allAttendance.assignAll(
        snapshot.docs.map((doc) => AttendanceRecord.fromFirestore(doc)).toList()
      );
      isLoading.value = false;
    });
  }

   //build attendance stat
  Widget buildAttendanceStat(){
    return Obx((){
      final present = allAttendance.length;
      final total = participantLength;

      return Card(
        margin: EdgeInsets.all(16),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard('Present', '$present'),
              _buildStatCard('Absent', '${total - present}'),
              _buildStatCard('Total', '$total' ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStatCard(String title, String value){
    return Column(
      spacing: 4,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }

  //build participants list
  Widget buildAttendanceList(){
    return Expanded(
      child: Obx((){
        if(isLoading.value){
          return Center(child: CircularProgressIndicator(color: Colors.white,));
        }
        final students  = filteredAttendance;

        if(students.isEmpty){
          return Center(
            child: ClipRRect(
              child: Image.asset(
                'assets/in_app_images/empty.png',
                fit: BoxFit.cover,
              ),
            
            ),
          );
        }
      
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            
            return _buildStudentTile(student);
          },
        );
      }
      
      ),
    );
  }

  //build participant tile
  Widget _buildStudentTile(AttendanceRecord record){
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey,
          child: Text(
            record.studentName[0],
          ),
        ),
        title: Text(
          record.studentName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20
          ),
        ),
        subtitle: Column(
          children: [
            Text(
              'ID: ${record.studentIdNumber}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 16
              ),
            ),
              Text(
                'Attended: ${DateFormat.MMMd().add_jm().format(record.timestamp)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16
                ),
             ),
          ],
        ),
        trailing: Chip(
            color: WidgetStateProperty.all(Colors.green),
            label: Text(
              'Present',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16
              ),
            ),
          )
      ),
    );
  }

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
  }
}