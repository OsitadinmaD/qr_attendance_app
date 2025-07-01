import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/sign_up/widgets/snackbar_message_show.dart';

class QRScannerController extends GetxController{
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
    final Size layoutSize = BoxConstraints().biggest;

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
      }
    );
  }

  Future<void> authenticateWithBiometrics(String qrData) async {
    final LocalAuthentication auth = LocalAuthentication();
    bool canAuthenticate = false;

    //Check if biometrics is available
    try {
      canAuthenticate = await auth.canCheckBiometrics || await auth.isDeviceSupported();
    } catch (e) {
      snackBarshow(
        title: 'Error', 
        message: 'Biometrics is not available', 
        backgroundColor: Colors.red, 
        icon: Icons.error_outline_rounded
      );
    }

    if(!canAuthenticate){
      snackBarshow(
        title: 'Error', 
        message: 'Error checking biometrics', 
        backgroundColor: Colors.red, 
        icon: Icons.error_outline_rounded
      );
      return;
    }

    //authenticate
    try {
      final bool authenticated = await auth.authenticate(
        localizedReason: 'Verify Your identity to mark attendance',
        options: AuthenticationOptions(
          useErrorDialogs: true,
          biometricOnly: true,
        )
      );

      if(authenticated){
        /// Todo: login for processing attendance
        snackBarshow(
          title: 'Success', 
          message: 'Biometrics verified successfully', 
          backgroundColor: Colors.green, 
          icon: Icons.error_outline_rounded
        );
      }else{
        snackBarshow(
          title: 'Error', 
          message: 'Biometrics verification failed', 
          backgroundColor: Colors.red, 
          icon: Icons.error_outline_rounded
        );
      }
    } catch (e) {
      snackBarshow(
        title: 'Error',
        message: 'Biometrics verification failed',
        backgroundColor: Colors.red,
        icon: Icons.error_outline_rounded
      );
    }
  }

  @override
  void onClose() {
    super.onClose();
    _scannerController.dispose();
  }
}