import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../model/session_model.dart';

class NewSessionController extends GetxController {
  Rx<String> sessionName = ''.obs;
  Rx<String> dateTime = ''.obs;
  Rx<DateTime> joindateTime = DateTime.now().obs;
  Rx<String> joinStartDateTime = ''.obs;
  Rx<String> joinEndDateTime = ''.obs;
  Rx<bool> generateQR = false.obs;
  Rx<String> qrID = ''.obs;
  RxList<SessionModel> sessions = <SessionModel>[].obs;

   

  late TextEditingController courseNameController;

  @override
  onInit(){
    super.onInit();
    courseNameController = TextEditingController();
  }

  addSessionToSessionsList(){
    String active(){
      if(sessions.length % 2 == 0){
        return 'Active';
      }else{
        return 'Not Active';
      }
    }
    if(sessionName.value != '' && joinEndDateTime.value != '' && joinStartDateTime.value != '' &&
      dateTime.value != ''){
       sessions.add(SessionModel(sessionName: sessionName.value, dateTime: dateTime.value, active: active()));
    }
  }



  String dateTimeButton(){
    if(dateTime.value == ''){
      return 'Select';
    }else{
      return dateTime.value;
    }
  }

  String joiStartDateTimeButton(){
    if(joinStartDateTime.value == ''){
      return 'Select';
    }else{
      return joinStartDateTime.value;
    }
  }

  String joinEndDateTimeButton(){
    if(joinEndDateTime.value == ''){
      return 'Select';
    }else{
      return joinEndDateTime.value;
    }
  }

  dateTimePicker(BuildContext context) async {
    showDatePicker(
      context: context, 
      firstDate: DateTime(2023), 
      lastDate: DateTime(2050),
      cancelText: 'cancel',
      confirmText: 'ok',
    ).then((date){
      showTimePicker(
        // ignore: use_build_context_synchronously
        context: context, 
        initialTime: TimeOfDay.now(),
      ).then((time){
        // ignore: use_build_context_synchronously
        dateTime.value = '${date!.toString()} ${time!.format(context)}';
      });
    });
  }

  joindateTimePicker(BuildContext context) async {
    showDatePicker(
      context: context, 
      firstDate: DateTime(2023), 
      lastDate: DateTime(2050),
      cancelText: 'cancel',
      confirmText: 'ok',
    ).then((date){
      showTimePicker(
        // ignore: use_build_context_synchronously
        context: context, 
        initialTime: TimeOfDay.now(),
      ).then((time){
        // ignore: use_build_context_synchronously
        joinStartDateTime.value = '${date!.toString()} ${time!.format(context)}';
      });
    });
  }

  enddateTimePicker(BuildContext context) async {
    showDatePicker(
      context: context, 
      firstDate: DateTime(2023), 
      lastDate: DateTime(2050),
      cancelText: 'cancel',
      confirmText: 'ok',
    ).then((date){
      showTimePicker(
        // ignore: use_build_context_synchronously
        context: context, 
        initialTime: TimeOfDay.now(),
      ).then((time){
        // ignore: use_build_context_synchronously
        joinEndDateTime.value = '${date!.toString()} ${time!.format(context)}';
      });
    });
  }

  qrCodeID(){
    if(sessionName.isNotEmpty && joinEndDateTime.isNotEmpty && joinStartDateTime.isNotEmpty && dateTime.isNotEmpty){
      qrID.value = '${courseNameController.text} ${dateTime.value} ${DateTime.now()}';
    }else{
      Get.snackbar(
        'Error', 
        'All Text and Date Fields are Required',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
        mainButton: TextButton(
          onPressed: () => Get.back(), 
          child: Text(
            'Close',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600
            ),
          )
        )
      );
    }
  }

  Widget generateQrCode() {
    return Center(
      child: QrImageView(
        //Remember to add the logo image at the center of the QR code
        data: qrID.value,
        eyeStyle: QrEyeStyle(
          color: Colors.blue,
          eyeShape: QrEyeShape.square
        ),
        dataModuleStyle: QrDataModuleStyle(
          color: Colors.blue,
        ),
      ),
    );
  }

  saveQRDataToBase() {
    if(sessionName.value == '' && joinEndDateTime.value == '' && joinStartDateTime.value == '' &&
      dateTime.value == ''){
        Get.snackbar(
          'Error', 'Text Fields and Date Fields are empty',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          mainButton: TextButton(
          onPressed: () => Get.back(), 
          child: Text(
            'Close',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600
            ),
          )
        ),          
        snackPosition: SnackPosition.TOP
       );
      }else{
        Get.snackbar(
          'Success', 'Session Created Successfully',
          colorText: Colors.white,
          backgroundColor: Colors.green,
          mainButton: TextButton(
            onPressed: () => Get.back(), 
            child: Text(
              'Close',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600
              ),
            )
          ),
          snackPosition: SnackPosition.TOP
        );
        addSessionToSessionsList();
        qrID.value = '';
        sessionName.value = '';
        dateTime.value = '';
        courseNameController.text = '';
        joinEndDateTime.value = '';
        joinStartDateTime.value = '';
      }
  }

  @override
  void onClose() {
    super.onClose();
    courseNameController.dispose();
  }
}