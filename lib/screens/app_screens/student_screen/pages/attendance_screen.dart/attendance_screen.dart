import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'controller/fetch_student_attendance.dart';

class AttendanceHistory extends StatelessWidget {
  const AttendanceHistory({super.key,});

  @override
  Widget build(BuildContext context) {
    final FetchStudentAttendance controller = Get.put(FetchStudentAttendance());
    //fetch data when the screen is first built
    controller.fetchStudentAttendance();
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.blue,));
        }
        if (controller.classes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.event_available_rounded, size: 64, color: Colors.grey,),
                const SizedBox(height: 16,),
                Text(
                  'No attendance record found',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 8,),
                Text(
                  'All successful attendance will be seen here',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                )
              ],
            ),
          );
        }

        
        return ListView.builder(
          itemCount: controller.classes.length,
          itemBuilder: (context, index) {
            final classAttended = controller.classes[index];

            return Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  Icon(
                    Icons.person, 
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        classAttended.studentName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 15
                        ),
                      ),
                      Text(
                        'ID: ${classAttended.studentIdNumber}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 12
                        ),
                      ),
                      Text(
                        'Department: ${classAttended.department}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 12
                        ),
                      ),
                      Text(
                        //will be corected
                        'Recorded at: ${DateFormat.MMMd().add_jm().format(classAttended.timestamp)}',// Update from firestore
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 12
                        ),
                      ),
                      Chip(
                        color: WidgetStateProperty.all(Colors.green.shade300),//update this from the participant collection
                        label: Text(
                          'Attendance taken successfully',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 12
                          ),
                        ),
                      ) 
                    ],
                  )
                ],
              ),
            )
           );
          },
        );
      }),
    );
  }
}