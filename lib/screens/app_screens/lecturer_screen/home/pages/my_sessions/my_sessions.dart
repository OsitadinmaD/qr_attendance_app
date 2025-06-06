import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/pages/my_sessions/controller/sessions_controller.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/login_screen/controller/login_controller.dart';

import 'model/session_model.dart';

class MySessionsPage extends StatefulWidget {
  const MySessionsPage({
    super.key,
  });

  @override
  State<MySessionsPage> createState() => _MySessionsPageState();
}

class _MySessionsPageState extends State<MySessionsPage> {
  final SessionsController fetchSessionsController = Get.find<SessionsController>();
  final String lecturerId = Get.find<LoginController>().user.value!.uid;

  @override
  void initState(){
    fetchSessionsController.getLecturerSessionStream(lecturerId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,

      child: StreamBuilder(
            stream: fetchSessionsController.getLecturerSessionStream(lecturerId), 
            builder: (context, snapshot){
              if(snapshot.hasError){
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                );
              }
              if (!snapshot.hasData){
                return Center(child: CircularProgressIndicator(color: Colors.blue,),);
              }

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  SessionModel data = snapshot.data![index];

                  return Card(
                    margin: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: Colors.blueGrey.shade200,
                    child: ListTile(
                      onTap: (){},
                      title: Text(
                        data.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                      subtitle: Text(
                        data.description,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),
                      ),
                      trailing: data.isQRActive ? 
                        Text(
                          'Active',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Colors.green
                          ),
                        ):
                        Text(
                          'Inactive',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        )
                    ),
                  );
                },
              );
            }
          )
    );
  }
}
