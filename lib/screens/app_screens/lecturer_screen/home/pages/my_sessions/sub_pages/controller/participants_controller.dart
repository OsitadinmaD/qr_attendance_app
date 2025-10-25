import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_attendance_app/constants/helpers/snackbar_message_show.dart';

import '../../../../../../../auth_screens.dart/sign_up/user_model/user_model.dart';
import 'attendance_record_controller.dart';

class ParticipantsController extends GetxController {
  final String sessionId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<UserModel> allParticipants = <UserModel>[].obs;
  RxList<UserModel> filteredParticipants = <UserModel>[].obs;
  RxInt totalPartcicipants = 0.obs;
  RxString searchQuery = ''.obs;
  RxBool isLoading = true.obs;

  final searchController = TextEditingController();

  ParticipantsController({required this.sessionId});
  

  @override
  void onInit() {
    super.onInit();
    _setUpParticipantsStream();
    //React to search changes
    ever(searchQuery, (_) => _filterParticipants());
  }

  //set current session and fetch participant
  void _setUpParticipantsStream() async {
    isLoading.value = true;
    try {
      _firestore
      .collection('participants')
      .where('sessionId', isEqualTo: sessionId)
      .orderBy('joinedAt', descending: true)
      .snapshots()
      .listen((snapshot) {
        totalPartcicipants.value = snapshot.docs.length;

        if (snapshot.docs.isEmpty){
          allParticipants.value = [];
          filteredParticipants.value = [];
          isLoading.value = false;
          return;
        }

        _loadUserDetails(snapshot.docs);

      });
    } catch (e) {
      SnackbarMessageShow.errorSnack(title: 'Error', message: 'Could not load participants', );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadUserDetails(List<DocumentSnapshot> participantDocs) async {
    try {
      isLoading.value = true;
      final userIds = participantDocs.map((doc) => doc['studentId'] as String).toList();

      final users = await Future.wait(
        userIds.map((uid) async {
          final userDoc = await _firestore
            .collection('usersData')
            .doc(uid)
            .get();

          return UserModel.fromFirestore(userDoc.data()!);
        })
      );

      allParticipants.value = users;
      _filterParticipants();//Apply current search filter
    } catch (e) {
      SnackbarMessageShow.errorSnack(
        title: 'Error', 
        message: 'Failed to load participants', 
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _filterParticipants(){
    if(searchQuery.value.isEmpty){
      filteredParticipants.value = allParticipants;
    } else {
      filteredParticipants.value = allParticipants.where((user){
        return user.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          user.idNumber.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }
  }

  void updateSearchQuery(query){
      searchQuery.value = query;
  }

  //build attendance stat
  Widget buildAttendanceStat(){
    final attendeesController = Get.put(AttendeesController());
    return Obx((){

      return Card(
        margin: EdgeInsets.all(16),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard('Total', '${totalPartcicipants.value}'),
              _buildStatCard('Present', '${attendeesController.sessionAttendees.length}'),
              _buildStatCard('Absent', '${totalPartcicipants.value - attendeesController.sessionAttendees.length}'),
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
  Widget buildParticipantList(){
    return Expanded(
      child: Obx((){
        if(isLoading.value){
          return Center(child: CircularProgressIndicator(color: Colors.blue,),);
        }

        if(filteredParticipants.isEmpty){
          return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.event_available_rounded, size: 64, color: Colors.grey,),
              const SizedBox(height: 16,),
              Text(
                'No participants yet',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),
              ),
              const SizedBox(height: 8,),
              Text(
                'Participants will be seen here',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),
              )
            ],
          ),
        );
        }
      
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: filteredParticipants.length,
          itemBuilder: (context, index) {
            final participant = filteredParticipants[index];
            
            return _buildParticipantTile(participant);
          },
        );
      }
      ),
    );
  }

  //build participant tile
  Widget _buildParticipantTile(UserModel participant){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade200,
              child: Text(
                participant.name[0]
              ),
            ),
        
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participant.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(0, 0, 0, 1),
                    fontSize: 15
                  ),
                ),
                Text(
                  'ID: ${participant.idNumber}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(0, 0, 0, 1),
                    fontSize: 12
                  ),
                ),
                Text(
                  'Department: ${participant.department}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(0, 0, 0, 1),
                    fontSize: 12
                  ),
                ),
                Text(
                  //will be corected
                  'Joined at: ${DateFormat.MMMd().add_jm().format(DateTime.now())}',// Update from firestore
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(0, 0, 0, 1),
                    fontSize: 12
                  ),
                ) 
              ],
            )
            
          ],
        ),
      )
    );
  }

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
  }
}