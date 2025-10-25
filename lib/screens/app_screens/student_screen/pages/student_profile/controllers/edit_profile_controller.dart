
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_attendance_app/constants/helpers/snackbar_message_show.dart';

class EditProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;
  RxString message = ''.obs;
  late TextEditingController nameController;
  late TextEditingController departmentController;
  late TextEditingController matricNumberController;

  @override
  onInit() {
    super.onInit();
    nameController = TextEditingController();
    departmentController = TextEditingController();
    matricNumberController = TextEditingController();
    // Load initial profile data if needed
  }

  @override
  onClose() {
    super.onInit();
    nameController.dispose();
    departmentController.dispose();
    matricNumberController.dispose();
  }

  // New method for partial profile updates
  Future<void> updateProfile() async {
    isLoading.value = true;
    message.value = 'Updating profile...';

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      message.value = 'Error: No authenticated user found.';
      SnackbarMessageShow.errorSnack(title:'Update Failed',message: message.value,);
      isLoading.value = false;
      return;
    }

    final Map<String, dynamic> updateData = {};

    // Only add the field to the map if it's not null and not empty
    if (nameController.text.trim().isNotEmpty) {
      updateData['name'] = nameController.text.trim();
    }
    if (departmentController.text.trim().isNotEmpty) {
      updateData['department'] = departmentController.text.trim();
    }
    if (matricNumberController.text.trim().isNotEmpty) {
      updateData['matricNumber'] = matricNumberController.text.trim();
    }

    // Check if there are any fields to update
    if (updateData.isEmpty) {
      message.value = 'No fields to update.';
      SnackbarMessageShow.infoSnack(title:'No Changes',message: message.value,);
      isLoading.value = false;
      return;
    }
    
    // Add the timestamp for tracking
    updateData['lastUpdated'] = FieldValue.serverTimestamp();

    try {
      await _firestore.collection('users').doc(userId).update(updateData);
      message.value = 'Profile updated successfully!';
      SnackbarMessageShow.successSnack(title:'Success',message: message.value,);
    } catch (e) {
      message.value = 'An unexpected error occurred: ${e.toString()}';
      SnackbarMessageShow.errorSnack(title:'Update Error',message: message.value,);
    } finally {
      isLoading.value = false;
    }
 }
}