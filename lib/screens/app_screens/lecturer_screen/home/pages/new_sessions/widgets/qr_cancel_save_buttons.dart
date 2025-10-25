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
              if(cancelSaveController.description.value == ''  && cancelSaveController.department.value == ''
                 && cancelSaveController.title.value == ''){
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
                      backgroundColor: Theme.of(context).primaryColorLight,
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
                        ElevatedButton(
                          onPressed: (){
                            cancelSaveController.qrCodeData.value = '';
                            cancelSaveController.description.value = '';
                            cancelSaveController.department.value = '';
                            cancelSaveController.departmentTextController.text = '';
                            cancelSaveController.descriptionTextController.text = '';
                            cancelSaveController.title.value = '';
                            cancelSaveController.titleController.text = '';
                            cancelSaveController.selectedJoinStartDate.value = DateTime.now();
                            cancelSaveController.selectedJoinEndDate.value = DateTime.now().add(Duration(days: 1));
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
              height: MediaQuery.of(context).size.height * 0.055,
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
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () => cancelSaveController.toggleInput.value ? null: cancelSaveController.saveQRDataToBase(),
            splashColor: Colors.black,
            child: Obx( () => Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height * 0.055,
                decoration: BoxDecoration(
                  color: cancelSaveController.toggleQrInputs() ? Theme.of(context).colorScheme.primary : Theme.of(context).primaryColorLight,
                  //border: Border.all(color: Colors.black, width: 1.5),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: cancelSaveController.toggleInput.value ? Center(child: CircularProgressIndicator(color: Colors.white,)) : Center(
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                    ),
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