import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/lecturer_screen/home/pages/my_sessions/sub_pages/widgets/attendance_participants_screens.dart';
import 'package:qr_attendance_app/screens/app_screens/student_screen/pages/tabbar.dart';

import '../session model/session_model.dart';

class ParticpantsAttendantsScreen extends StatefulWidget {
  const ParticpantsAttendantsScreen({super.key, required this.session});

  final SessionModel session;

  @override
  State<ParticpantsAttendantsScreen> createState() => _ParticpantsAttendantsScreenState();
}

class _ParticpantsAttendantsScreenState extends State<ParticpantsAttendantsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back() , 
          icon: Icon(Icons.arrow_back_rounded,color: Colors.white, size: 25,)
        ),
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: Icon(Icons.download_rounded,size: 20,color: Colors.white,)
          )
        ],
        backgroundColor: Colors.blue,
        title: Text(
          'INFO: ${widget.session.title}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            overflow: TextOverflow.fade
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            children: [
              SizedBox(height: 5,),
              SessionTabBarView.tabBar(
                tabController: _tabController,
                tab1Label: 'Participants',
                tab2Label: 'Attendees',
              ),
              SessionTabBarView().sessionTabBarView(
                tabController: _tabController,
                tab1Page: AttendanceParticipantsScreens().buildParticipantScreen(widget.session),
                tab2Page: AttendanceParticipantsScreens().buildAttendanceScreen(widget.session),
              ),
            ],
          )
        ),
      ),
    );
  }
}