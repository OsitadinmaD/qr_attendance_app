import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/pages/new_sessions/controller/new_session_controller.dart';

class QRCodeInputs extends StatelessWidget {
  const QRCodeInputs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final qrDataController = Get.put<NewSessionController>(NewSessionController());
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Theme.of(context).colorScheme.primary,),
              Text(
                'Input Session details.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Divider(color: Theme.of(context).colorScheme.primary,),
              const SizedBox(height: 10,),
            Text(
                'Course Title',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5,),
            TextField(
              controller: qrDataController.titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'Course code: Title'
              ),
              autocorrect: true,
              keyboardType: TextInputType.text,
              onChanged: (courseName) {
                qrDataController.title.value = courseName;
              },
            ),
            const SizedBox(height: 3,),
             Text(
                'eg., CSC 102: Introduction to Computer science',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ), 
              const SizedBox(height: 10,),
              Text(
                'Department',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5,),
              TextField(
                controller: qrDataController.departmentTextController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  hintText: 'Department'
                ),
                autocorrect: true,
                keyboardType: TextInputType.text,
                onChanged: (department){
                  qrDataController.department.value = department;
                },
              ),
              const SizedBox(height: 3,),
             Text(
                'eg., Computer Science',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                'Venue Description',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5,),
              TextField(
                maxLines: 3,
                controller: qrDataController.descriptionTextController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  hintText: 'Describe venue and time',
                ),
                autocorrect: true,
                keyboardType: TextInputType.text,
                onChanged: (description) {
                  qrDataController.description.value = description;
                },
              ),
              const SizedBox(height: 3,),
             Text(
                'eg., Venue: FSLT1, Time: 2pm, Date: 12th April, 2025',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15,),
              Divider(color: Theme.of(context).colorScheme.primary,),
              Text(
                'Select time for Students to join session and the deadline.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Divider(color: Theme.of(context).colorScheme.primary,),
              const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                'Join Start Time:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
                GestureDetector(
                  onTap: () => qrDataController.selectJoinStartTime(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: List.filled(1, BoxShadow(color: Theme.of(context).colorScheme.primary,blurRadius: 1,spreadRadius: 0.5))
                    ),
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Obx(() => Center(
                        child: Text(
                            formatter.format(qrDataController.selectedJoinStartDate.value).toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black
                            )
                          ),
                      ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                'Join Deadline:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
                GestureDetector(
                  onTap: () => qrDataController.selectJoinEndTime(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: List.filled(1, BoxShadow(color: Theme.of(context).colorScheme.primary,blurRadius: 1,spreadRadius: 0.5))
                    ),
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Obx( () => Center(
                          child: Text(
                                formatter.format(qrDataController.selectedJoinEndDate.value).toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black
                                )
                              ),
                        )
                          ),
                      ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}