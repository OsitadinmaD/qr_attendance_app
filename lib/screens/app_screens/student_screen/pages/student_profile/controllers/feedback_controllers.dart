import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/constants/helpers/snackbar_message_show.dart';

class FeedbackControllers extends GetxController {

  late TextEditingController titleController;
  late TextEditingController commentsController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    titleController = TextEditingController(text: 'Feedback');
    commentsController = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    titleController.dispose();
    commentsController.dispose();
  }

  Future<void> uploadFeedback() async {
    isLoading.value = true;
    try {
      if(_auth.currentUser == null){
        return;
      }

      String userId = _auth.currentUser!.uid;

      final data = await _firestore.collection('usersData').doc(userId).get();

      if(!data.exists) return;

      final userData = data.data()!;


      _firestore.collection('feedback')
        .add({
          'userName': userData['name'],
          'userEmail' : userData['email'],
          'title': titleController.text,
          'comments': commentsController.text
        }).whenComplete(() {
          SnackbarMessageShow.infoSnack(title: 'Feedback sent', message: 'Thanks for your feedback, this can go a long way to help us improve our services',);
          titleController.text = '';
          commentsController.text = '';
        });
    } catch (e) {
      SnackbarMessageShow.errorSnack(title: 'Error', message: 'Could not send feedback across\n Please try again!',);
    } finally {
      isLoading.value = false;
    }
  }

}