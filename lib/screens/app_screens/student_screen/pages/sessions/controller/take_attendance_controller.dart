import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/pages/my_sessions/session%20model/session_model.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/sign_up/widgets/snackbar_message_show.dart';

class TakeAttendanceController extends GetxController {
  RxString qrData = ''.obs;
  late MobileScannerController _scannerController;

  @override
  void onInit() {
    super.onInit();
    _scannerController = MobileScannerController();
  }

  Future<void> scanQr() async {
    final cameraStatus = await Permission.camera.status ;

    if(cameraStatus.isPermanentlyDenied){
      Get.dialog(
        AlertDialog(
          title: Text(
            'Access Request',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600
            ),
          ),
          backgroundColor: Colors.blue.shade300,
          content: Text(
            'Please camera access is needed to scan QR codes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => openAppSettings(), 
              child: Text(
                'Open Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),
              ),
            )
          ],
          icon: Icon(Icons.info_outline_rounded,size: 25, color: Colors.white,),
        )
      );
    }else if(!cameraStatus.isGranted){
      Permission.camera.request();
    }else{
      Get.to(() => MobileScanner());
    }

  }

  MobileScanner mobileScanner() {
    final Size layoutSize = BoxConstraints().smallest;

    final double scanWindowWidth = layoutSize.width / 3;
    final double scanWindowHeight = layoutSize.height / 2;

    return MobileScanner(
      controller: _scannerController,
      fit: BoxFit.cover,
      scanWindow: Rect.fromCenter(
        center: layoutSize.center(Offset.zero), 
        width: scanWindowWidth, 
        height: scanWindowHeight
      ),
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        for(final barcode in barcodes){
          qrData.value = barcode.rawValue!;
          _scannerController.stop();
        }
        processAttendanceAfterBiometrics(qrData.value);
      }
    );
  }

  //1. Students attendance marking logic
  Future<void> processAttendanceAfterBiometrics(String scannedData) async {
    try{
      //parse and validate Qr code
      final sessionId = _parseQRData(scannedData);
      if (sessionId == null) throw 'Invalid QR code';

      //validate session status
      final SessionModel session = await _getSession(sessionId);
      if(!session.isQRActive) throw 'Attendance not active';
      if(DateTime.now().isAfter(session.joinEndTime)) throw 'Attendance windows closed';

      // check existing attendance
      if(await _hasAttendanceRecord(sessionId)) throw 'Attendance already recoreded';

      //Perform biometric authentication
      final authResult = await _authenticateWithbiometrics();
      if (!authResult) throw 'Biometric verification failed';

      //Record attendance
      await _recordAttendance(sessionId);

      // show success
      Get.back();
      snackBarshow(
        title: 'Success', 
        message: 'Attendance recorded!', 
        backgroundColor: Colors.green, 
        icon: Icons.check_circle
      );
    } catch (e){
      snackBarshow(
        title: 'Error', 
        message: e.toString(), 
        backgroundColor: Colors.red, 
        icon: Icons.error
      );
    }
  }

  //Helper function
  String? _parseQRData(String data){
    try {
      final parts = data.split('::');
      if(parts.length != 2) return null;
      return parts[0];
    } catch (_) {
      return null;
    }
  }

  Future<SessionModel> _getSession(String sessionId) async {
    final doc = await FirebaseFirestore.instance.collection('sessions').doc(sessionId).get();
    if(!doc.exists) throw 'Session not found';
    return SessionModel.fromFirestore(doc);
  }

  Future<bool> _hasAttendanceRecord(String sessionId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = FirebaseFirestore.instance  
      .collection('attendance')
      .where('sessionId', isEqualTo: sessionId)
      .where('studentId', isEqualTo: userId)
      .limit(1)
      .get();
      // come back here
      return snapshot.toString().isNotEmpty;
  }

  Future<bool> _authenticateWithbiometrics() async{
    final localAuth =LocalAuthentication();
    return await localAuth.authenticate(
      localizedReason:'Verify Attendance',
      options: const AuthenticationOptions(biometricOnly: true)
    );
  }

  Future<void> _recordAttendance(String sessionId) async{
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final timeStamp = FieldValue.serverTimestamp();
    
    await FirebaseFirestore.instance.collection('attendance').add({
      'sessionId': sessionId,
      'studentId':userId,
      'timeStamp': timeStamp,
      'biometricVerified':false,
      //'deviceId': await _getDeviceId;
    });
  }

}