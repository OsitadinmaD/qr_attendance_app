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
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        spacing: 10,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
              boxShadow: List.filled(1, BoxShadow(color: Colors.black38,blurRadius: 1,spreadRadius: 0.5))
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.06,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: qrDataController.courseNameController,
                cursorColor: Colors.black,
                decoration: InputDecoration.collapsed(hintText: 'Course Name'),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500
                ),
                autocorrect: true,
                keyboardType: TextInputType.text,
                onChanged: (courseName) {
                  qrDataController.sessionName.value = courseName;
                },
              ),
            )
            ),
          GestureDetector(
            onTap: () => qrDataController.dateTimePicker(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
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
                      'Date and Time of Lecture',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                      )
                    ),
                    Obx( () => Text(
                          qrDataController.dateTimeButton(),
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
            onTap: () => qrDataController.joindateTimePicker(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
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
                        'Start time for Student to join session',
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black
                        )
                      ),
                      Obx( () => Text(
                            qrDataController.joiStartDateTimeButton(),
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
            onTap: () => qrDataController.enddateTimePicker(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
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
                            qrDataController.joinEndDateTimeButton(),
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
    );
  }
}