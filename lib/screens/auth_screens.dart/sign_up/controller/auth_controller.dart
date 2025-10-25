import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/constants/helpers/snackbar_message_show.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/sign_up/user_model/app_user.dart';

class AuthController extends GetxController {
  final Rxn<AppUser> currentUser = Rxn<AppUser>();
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    _setupAuthListener();
    super.onInit();
  }

  void _setupAuthListener() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if(user == null){
        currentUser.value = null;
        isLoading.value = false;
        return;
      }

      try {
        final doc = await FirebaseFirestore.instance.collection('usersData').doc(user.uid).get();

        if(doc.exists){
          currentUser.value = AppUser.fromFirebaseUser(user, doc.data()!);
        }else{
          //Create user document if missing
          await _createUserDocument(user);
        }
      } catch (e) {
        SnackbarMessageShow.errorSnack(title: 'Error', message: 'Failed to load User data',);
      } finally {
        isLoading.value = false;
      }
    });
  }

  Future<void> _createUserDocument(User user) async {
    await FirebaseFirestore.instance
      .collection('usersData')
      .doc(user.uid)
      .set({
        'userId':user.uid,
        'idNumber': 'Unknown',
        'email': user.email,
        'name': user.displayName ?? user.email!.split('@').first,
        'isLecturer': false,
        'department': 'Unknown',
        'createdAt': FieldValue.serverTimestamp()
      });

    currentUser.value = AppUser(uid: user.uid, email: user.email!, isLecturer: false, name: user.displayName ?? user.email!.split('@').first);
  }
  

}