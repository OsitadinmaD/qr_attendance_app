import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/pages/new_sessions/controller/new_session_controller.dart';

class MySessionsPage extends StatelessWidget {
  const MySessionsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mySessionsController = Get.put<NewSessionController>(NewSessionController());
    return Obx( () => Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(height: 4,),
            padding: EdgeInsets.all(4),
            itemCount: mySessionsController.sessions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  mySessionsController.sessions[index].sessionName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  mySessionsController.sessions[index].dateTime,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                trailing: Text(
                  mySessionsController.sessions[index].active,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: mySessionsController.sessions[index].active =='Active' ? Colors.green : Colors.red,
                  ),
                ),
                tileColor: Colors.blueGrey,
                style: ListTileStyle.drawer,
              );
              
            },
          ),
        )
      ),
    );
  }
}
