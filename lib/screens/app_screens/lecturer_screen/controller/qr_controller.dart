import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class  QrController extends GetxController {
   QrController get() => Get.find<QrController>();

  Rx<String> classSessionId = ''.obs;
  Rx<String> dateTime = ''.obs;

  Widget generateQrCode() {
    return Center(
      child: QrImageView(
        data: '',
        version: QrVersions.auto,
        //backgroundColor: PColors.black,
        size: 250,
      ),
    );
  }
}