import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/pages/my_sessions/controller/sessions_controller.dart';

import 'session model/session_model.dart';
import 'sub_pages/sub_screen.dart';

class MySessionsPage extends StatefulWidget {
  const MySessionsPage({
    super.key,
  });

  @override
  State<MySessionsPage> createState() => _MySessionsPageState();
}

class _MySessionsPageState extends State<MySessionsPage> {
  final SessionsController fetchSessionsController = Get.find<SessionsController>();
  final String lecturerId = FirebaseAuth.instance.currentUser!.uid;

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
                    color: Colors.white,
                    child: ListTile(
                      onTap: () async => await Get.to(() => ParticpantsAttendantsScreen(session: data,)),
                      title: Text(
                        data.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            data.description,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.black
                            ),
                          ),
                          Text(
                            data.isQRActive ? 'QR is activated' : 'QR is not activated',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: data.isQRActive ? Colors.green : Colors.red
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () => fetchSessionsController.showQrCode(data), 
                        icon: Icon(Icons.qr_code_2_rounded, size: 30, color: Colors.black,),
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
