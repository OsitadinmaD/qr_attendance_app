import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/pages/new_sessions/controller/new_session_controller.dart';

class QRCodeInputs extends StatelessWidget {
  const QRCodeInputs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final qrDataController = Get.put<NewSessionController>(NewSessionController());
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 10,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: List.filled(1, BoxShadow(color: Colors.black38,blurRadius: 1,spreadRadius: 0.5))
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.06,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: qrDataController.titleController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration.collapsed(hintText: 'Course Title'),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                  ),
                  autocorrect: true,
                  keyboardType: TextInputType.text,
                  onChanged: (courseName) {
                    qrDataController.title.value = courseName;
                  },
                ),
              )
              ),
              Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: List.filled(1, BoxShadow(color: Colors.black38,blurRadius: 1,spreadRadius: 0.5))
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.06,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: qrDataController.departmentTextController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration.collapsed(hintText: 'Department'),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                  ),
                  autocorrect: true,
                  keyboardType: TextInputType.text,
                  onChanged: (department){
                    qrDataController.department.value = department;
                  },
                ),
              )
              ),
              Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: List.filled(1, BoxShadow(color: Colors.black38,blurRadius: 1,spreadRadius: 0.5))
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.15,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  controller: qrDataController.descriptionTextController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration.collapsed(hintText: 'Describe the venue and time'),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                  ),
                  autocorrect: true,
                  keyboardType: TextInputType.text,
                  onChanged: (description) {
                    qrDataController.description.value = description;
                  },
                ),
              )
              ),
            GestureDetector(
              onTap: () => qrDataController.selectJoinStartTime(context),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: List.filled(1, BoxShadow(color: Colors.black38,blurRadius: 1,spreadRadius: 0.5))
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.06,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text(
                        'Time for students to start joining session',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black
                        )
                      ),
                      Obx( () => Text(
                            qrDataController.selectedJoinStartDate.value.toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black
                            )
                          )
                        ),
                    ]
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => qrDataController.selectJoinEndTime(context),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: List.filled(1, BoxShadow(color: Colors.black38,blurRadius: 1,spreadRadius: 0.5))
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.06,
                child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Text(
                          'Deadline time for student to join Session',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black
                          )
                        ),
                        Obx( () => Text(
                              qrDataController.selectedJoinEndDate.value.toString(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black
                              )
                            )
                          ),
                      ]
                    ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}