import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/constants/helpers/snackbar_message_show.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:uuid/uuid.dart';

class NewSessionController extends GetxController {
  final Rx<String> title = ''.obs;
  final Rx<String> description = ''.obs;
  final Rx<String> department = ''.obs;
  //final Rx<String> joinStartTime = ''.obs;
  final Rx<DateTime> selectedJoinStartDate = DateTime.now().obs;
  final TimeOfDay currentJoinStartTime = TimeOfDay.now();
  final Rx<DateTime> selectedJoinEndDate = DateTime.now().add(Duration(hours: 10)).obs;
  final TimeOfDay currentJoinEndTime = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 1)));
  //final Rx<String> joinEndTime = ''.obs;
  final Rx<String> qrCodeData = ''.obs;
  final Rx<bool> generateQR = false.obs;
  final String _sessionId = Uuid().v4();
  final Rx<bool> toggleInput = false.obs;

  late TextEditingController titleController;
  late TextEditingController descriptionTextController;
  late TextEditingController departmentTextController;

  @override
  onInit(){
    super.onInit();
    titleController = TextEditingController();
    descriptionTextController = TextEditingController();
    departmentTextController = TextEditingController();
  }

  Future<void> selectJoinStartTime(BuildContext context) async{
    final DateTime? pickedDate = await showDialog<DateTime>(
      context: context, 
      builder: (BuildContext context){
        return Dialog(
          child: SizedBox(
            height: 400,
            child: SfDateRangePicker(
              selectionColor: Colors.blueGrey.shade100,
              backgroundColor: Colors.blueGrey.shade200,
              showTodayButton: true,
              viewSpacing: 10,
              headerStyle: DateRangePickerHeaderStyle(
                backgroundColor: Colors.blueGrey.shade300
              ),
              allowViewNavigation: true,
              initialSelectedDate: selectedJoinStartDate.value,
              minDate: DateTime.now(),
              maxDate: DateTime.now().add(Duration(days: 30)),
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.single,
              showNavigationArrow: true,
              onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                Get.back(result: dateRangePickerSelectionChangedArgs.value);
              },
            ),
          ),
        );
      }
    );

    if (pickedDate != null && pickedDate.isAfter(DateTime.now())) {
      // show time picker after date is selected 
      final TimeOfDay? pickedTime = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context, 
        initialTime: currentJoinStartTime,
        cancelText: 'Cancel',
        hourLabelText: 'Hour',
        minuteLabelText: 'Minute',
        confirmText: 'Confirm',
        barrierDismissible: true,
        initialEntryMode: TimePickerEntryMode.inputOnly
      );

      if (pickedTime != null) {
        selectedJoinStartDate.value = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }else{
      Get.back();
      SnackbarMessageShow.errorSnack(
        title: 'Error', 
        message: 'The join start can\'t be null',
      );
    }
  }

  Future<void> selectJoinEndTime(BuildContext context) async {
    DateTime? pickedDate = await showDialog(
      context: context, 
      builder: (BuildContext context){
        return Dialog(
          child: SizedBox(
            height: 400,
            child: SfDateRangePicker(
              selectionColor: Colors.blueGrey.shade100,
              backgroundColor: Colors.blueGrey.shade200,
              showTodayButton: true,
              viewSpacing: 10,
              headerStyle: DateRangePickerHeaderStyle(
                backgroundColor: Colors.blueGrey.shade300
              ),
              allowViewNavigation: true,
              onCancel: () => Get.back(),
              selectionMode: DateRangePickerSelectionMode.single,
              initialSelectedDate: selectedJoinEndDate.value,
              minDate: DateTime.now(),
              maxDate: DateTime.now().add(Duration(days: 30)),
              showNavigationArrow: true,
              view: DateRangePickerView.month,
              onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                Get.back(result: dateRangePickerSelectionChangedArgs.value);
              },
            ),
          ),
        );
      }
    );

    if (pickedDate != null && pickedDate.isAfter(selectedJoinStartDate.value)) {
      TimeOfDay? pickedTime = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context, 
        initialTime: currentJoinEndTime,
        cancelText: 'Cancel',
        hourLabelText: 'Hour',
        minuteLabelText: 'Minute',
        confirmText: 'Confirm',
        barrierDismissible: true,
        initialEntryMode: TimePickerEntryMode.inputOnly 
      );

      if (pickedTime != null) {
        selectedJoinEndDate.value = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute
        );
      }
    }else{
      Get.back();
      SnackbarMessageShow.errorSnack(
        title: 'Error', 
        message: 'The join end date must not be a day before join start date', 
      );
    }
  }

  qrCodeID(){
    if(toggleQrInputs()){
      qrCodeData.value = 'Session:$_sessionId:${DateTime.now().millisecondsSinceEpoch}';
    }else{
      SnackbarMessageShow.errorSnack(
        title: 'Error', 
        message: 'All Text and Date Fields are Required',
      );
    }
  }

  Widget generateQrCode() {
    return Center(
      child: QrImageView(
        //Remember to add the logo image at the center of the QR code
        data: qrCodeData.value,
        eyeStyle: QrEyeStyle(
          color: Colors.black,
          eyeShape: QrEyeShape.square
        ),
        dataModuleStyle: QrDataModuleStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  bool toggleQrInputs(){
    if(title.value.isNotEmpty  && description.value.isNotEmpty && department.value.isNotEmpty){
        return true;
    }else{
      return false;
    }
  }

  Future<void> saveQRDataToBase() async {
    if(toggleQrInputs()){
      toggleInput.value = true;
        try {
          FirebaseAuth currentUserAuth = FirebaseAuth.instance;
          FirebaseFirestore uploadSession = FirebaseFirestore.instance;
           uploadSession.collection('sessions')
            .add({
              'sessionId': _sessionId,
              'lecturerId': currentUserAuth.currentUser!.uid,
              'title':title.value,
              'description': description.value,
              'department': department.value,
              'joinStartTime':Timestamp.fromDate(selectedJoinStartDate.value),
              'joinEndTime':Timestamp.fromDate(selectedJoinEndDate.value),
              'qrCodeData': qrCodeData.value.trim(),
              'isQRActive': false,
              'createdAt': FieldValue.serverTimestamp()
            }).whenComplete(() { 
              //toggleInput.value = false;
              SnackbarMessageShow.successSnack(
              title: 'Success', 
              message: 'Session Created and Uploaded Successfully', 
             );}
            );
          qrCodeData.value = '';
          department.value = '';
          description.value = '';
          title.value = '';
          titleController.text = '';
          departmentTextController.text = '';
          descriptionTextController.text = '';
          selectedJoinEndDate.value = DateTime.now().add(Duration(days: 1));
          selectedJoinStartDate.value = DateTime.now();
        } catch (e) {
          toggleInput.value == false;
          SnackbarMessageShow.errorSnack(
            title: 'Error', 
            message: 'An Unexpected Error Ocurred \nPlease try again', 
          );
        } finally{
          toggleInput.value = false;
        }
  }
  }

  @override
  void onClose() {
    super.onClose();
    titleController.dispose();
    departmentTextController.dispose();
    descriptionTextController.dispose();
  }
}
