import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/constants/helpers/snackbar_message_show.dart';

class UserProfileController extends GetxController {
  final auth = FirebaseAuth.instance;
  RxString userName = ''.obs;
  RxString userEmail = ''.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit(){
    super.onInit();
    fetchUserName(auth.currentUser!.uid);
    fetchUserEmail(auth.currentUser!.uid);
  }

  Future<void> fetchUserName(String userId) async {
    try {
      isLoading.value = true;
      final name = await FirebaseFirestore.instance
        .collection('usersData')
        .doc(userId)
        .get();
      
      if(name.exists){
        userName.value = name.data()?['name'];
      }
    } catch (e) {
      SnackbarMessageShow.errorSnack(title: 'Error',message: 'Error fetching user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserEmail(String userId) async {
    try {
      isLoading.value = true;
      final name = await FirebaseFirestore.instance
        .collection('usersData')
        .doc(userId)
        .get();
      
      if(name.exists){
        userName.value = name.data()?['email'];
      }
    } catch (e) {
      SnackbarMessageShow.errorSnack(title: 'Error',message: 'Error fetching user data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}