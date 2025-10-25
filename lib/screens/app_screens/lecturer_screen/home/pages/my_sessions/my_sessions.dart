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

  //@override
  //void initState(){
    //WidgetsBinding.instance.addPostFrameCallback((_) {
      //fetchSessionsController.getLecturerSessionStream(lecturerId);
    //});
    //super.initState();
 // }

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width,

      child: StreamBuilder<List<SessionModel>>(
            stream: fetchSessionsController.getLecturerSessionStream(lecturerId), 
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: Colors.blue,),);
              }
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
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.event_available_rounded, size: 64, color: Colors.grey,),
                      const SizedBox(height: 16,),
              Text(
                        'No sessions joined yet',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 8,),
                      Text(
                        'Join available sessions to see them here',
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
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  SessionModel data = snapshot.data![index];
 
                  return Card(
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
                              color: data.isQRActive ? Theme.of(context).primaryColorLight : Colors.red[100]
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () => fetchSessionsController.showQrCode(data,context), 
                        icon: Icon(Icons.qr_code_2_rounded, size: 30, color: Theme.of(context).primaryColor,),
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
