import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../session model/session_model.dart';

class SessionsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //List to store sessions from firestore
  RxList<SessionModel> allSessions = <SessionModel>[].obs;
  RxList<SessionModel> activeSessions = <SessionModel>[].obs;

  //Read lecturers events as streams
  Stream<List<SessionModel>> getLecturerSessionStream(String lecturerId){
    return _firestore
    .collection('sessions')
    .where('lecturerId', isEqualTo: lecturerId)
    .orderBy('createdAt', descending: true)
    .snapshots()
    .map((snapshot) => snapshot.docs
      .map((doc) => SessionModel.fromFirestore(doc)).toList());
  }

  //Lecturer View QR code generator
  void showQrCode(SessionModel session){
    Get.dialog(
      useSafeArea: true,
      AlertDialog(
        title: Text(
          'QR Data: ${session.title}',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.fade
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          Row(
            spacing: 5,
            children: [
              ElevatedButton(
                onPressed: () => Get.back(), 
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                )
              ),
              ElevatedButton(
                onPressed: (){}, 
                child: Text(
                  session.isQRActive ? 'Deactivate QR' : 'Activate QR',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                )
              ),
            ],
          )
        ],
        content: QrImageView(
              //Remember to add the logo image at the center of the QR code
              data: session.qrCodeData,
              eyeStyle: QrEyeStyle(
                color: Colors.blue,
                eyeShape: QrEyeShape.square
              ),
              dataModuleStyle: QrDataModuleStyle(
                color: Colors.blue,
              ),
            ),
      )
    );
  }
}