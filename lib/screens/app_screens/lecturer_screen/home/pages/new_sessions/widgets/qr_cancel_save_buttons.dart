import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/pages/new_sessions/controller/new_session_controller.dart';

class QRCancelSaveButtons extends StatelessWidget {
  const QRCancelSaveButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cancelSaveController = Get.put<NewSessionController>(NewSessionController());
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: (){
              if(cancelSaveController.dateTime.value == '' && cancelSaveController.joinEndDateTime.value== ''
                && cancelSaveController.joinStartDateTime.value == '' && cancelSaveController.sessionName.value == ''){
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
                showDialog(
                  context: context, 
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.blueAccent,
                      title: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to forfeit creating session?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      actions: [
                        FilledButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Colors.blue)
                          ),
                          onPressed: (){
                            cancelSaveController.qrID.value = '';
                            cancelSaveController.dateTime.value = '';
                            cancelSaveController.sessionName.value = '';
                            cancelSaveController.courseNameController.text = '';
                            cancelSaveController.joinEndDateTime.value = '';
                            cancelSaveController.joinStartDateTime.value = '';
                            Get.back();
                          }, 
                          child: Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ),
                        OutlinedButton(
                          onPressed: () => Get.back(), 
                          child: Text(
                            'No',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        )
                      ],

                    );
                  },
                );
              }
            },
            splashColor: Colors.black,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.065,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w400
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () => cancelSaveController.saveQRDataToBase(),
            splashColor: Colors.black,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.065,
              decoration: BoxDecoration(
                color: Colors.blue,
                //border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}