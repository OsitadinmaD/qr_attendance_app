import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/pages/my_sessions/sub_pages/participant%20model/participant_model.dart';
import 'package:qr_attendance_app/screens/app_screens/student_screen/pages/sessions/attendance_model/attendance_model.dart';

class AttendanceRecordController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<AttendanceRecordModel> allAttendance = <AttendanceRecordModel>[].obs;
  final RxList<ParticipantModel> allParticipants = <ParticipantModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;
  late TextEditingController searchController;

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
  }

  List<AttendanceRecordModel> get filteredAttendance {
    if(searchQuery.value.isEmpty) return allAttendance;

    return allAttendance.where((record){
      return
      record.studentName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
      record.studentIdNumber.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  List<AttendanceRecordModel> get attendedStudents {
    return allAttendance.where((record) => record.attendanceMarked).toList();
  }

  List<ParticipantModel> get allParticipant{
    return allParticipants;
  }

  void loadAttendance(String sessionId){
    isLoading.value = true;

    // Load Participants stream
    _firestore.collection('participants')
      .where('sessionId', isEqualTo: sessionId)
      .snapshots()
      .listen((participantSnapshot){
        allParticipant.assignAll(
          participantSnapshot.docs.map((doc) => ParticipantModel.fromFirestore(doc)).toList()
        );
        _matchAttendanceWithParticipants();
      });

    // load attendance stream
    _firestore.collection('attendance')
      .where('sessionId', isEqualTo: sessionId)
      .snapshots()
      .listen((attendanceSnapshot) {
        allAttendance.assignAll(
          attendanceSnapshot.docs.map((doc) => AttendanceRecordModel.fromFirestore(doc)).toList()
        );
        _matchAttendanceWithParticipants();
    });
  }

  void _matchAttendanceWithParticipants(){
    //create attendance record for all participants
    final records = allParticipant.map((participant){
      final attendance = allAttendance.firstWhere(
        (attendee) => attendee.studentId == participant.studentId,
        orElse: () => AttendanceRecordModel.empty(participant),
      );
      return attendance;
    }).toList();

    allAttendance.assignAll(records);
    isLoading.value = false;
  }

   //build attendance stat
  Widget buildAttendanceStat(){
    return Obx((){
      final present = attendedStudents.length;
      final total = allParticipant.length;

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
  Widget _buildStudentTile(AttendanceRecordModel record){
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
            if(record.attendanceMarked)
              Text(
                'Attended: ${DateFormat.MMMd().add_jm().format(record.markedAt!)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16
                ),
             ),
          ],
        ),
        trailing: record.attendanceMarked ?
          Chip(
            color: WidgetStateProperty.all(Colors.green),
            label: Text(
              'Present',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16
              ),
            ),
          ) : 
          Chip(
            color: WidgetStateProperty.all(Colors.red),
            label: Text(
              'Absent',
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