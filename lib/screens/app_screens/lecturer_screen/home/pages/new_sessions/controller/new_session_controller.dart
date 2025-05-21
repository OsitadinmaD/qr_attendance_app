import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../model/session_model.dart';

class NewSessionController extends GetxController {
  final Rx<String> sessionName = ''.obs;
  final Rx<String> dateTime = ''.obs;
  final Rx<DateTime> joindateTime = DateTime.now().obs;
  final Rx<String> joinStartDateTime = ''.obs;
  final Rx<String> joinEndDateTime = ''.obs;
  final Rx<bool> generateQR = false.obs;
  final Rx<String> qrID = ''.obs;

   

  late TextEditingController courseNameController;

  @override
  onInit(){
    super.onInit();
    courseNameController = TextEditingController();
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

  Future<void> saveQRDataToBase() async {
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
        FirebaseFirestore uploadSession = FirebaseFirestore.instance;
        await uploadSession.collection('session')
          .add({
            'sessionName':sessionName,
            'dateTime':dateTime,
            'joindateTime':joindateTime,
            'joinStartDateTime':joinStartDateTime,
            'joinEndDateTime':joinEndDateTime,
            'qrID':qrID,
          });
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
        qrID.value = '';
        sessionName.value = '';
        dateTime.value = '';
        courseNameController.text = '';
        joinEndDateTime.value = '';
        joinStartDateTime.value = '';
      }
  }
  
  Widget getSessionsListView() {
    FirebaseFirestore sessions = FirebaseFirestore.instance;
    return StreamBuilder(
      stream: sessions
        .collection('sessions')
        .orderBy('timestamp',descending: true)
        .snapshots(), 
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Center(
            child: Text(
              'Error: ${snapshot.error.toString()}'
            ),
          );
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(color: Colors.blue,)
          );
        }
        if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
          return Center(
            child: Text(
              'No Session found',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.blue
              ),
            ),
          );
        }

        final sessions = snapshot.data!.docs.map((doc){
          return SessionModel.fromMap(
            doc.data(), doc.id
          );
        }).toList();

        return ListView.separated(
          itemBuilder: (context, index) {
            final session = sessions[index];
            return ListTile(
              title: Text(session.sessionName),
              subtitle: Text(session.dateTime),
              trailing: Text(session.joinEndDateTime),
              onTap: (){},
            );
          }, 
          separatorBuilder: (context, index) => Divider(), 
          itemCount: sessions.length,
        );
      }
    );
  }

  @override
  void onClose() {
    super.onClose();
    courseNameController.dispose();
  }
}