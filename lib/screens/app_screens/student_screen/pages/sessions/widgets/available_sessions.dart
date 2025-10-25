import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/student_screen/pages/sessions/controller/active_sessions_controller.dart';
import 'package:qr_attendance_app/screens/app_screens/student_screen/pages/sessions/participant_model/participant_model.dart';
import 'package:qr_attendance_app/screens/app_screens/student_screen/pages/sessions/widgets/qr_scanner_page.dart';
import '../../../../../../util/permissions_service.dart';
import '../../../../lecturer_screen/home/pages/my_sessions/session model/session_model.dart';
import '../controller/attendance_controller.dart';

class AvailableSessions {

  AvailableSessions(); 

  Widget buildActiveSessionStream(){
    final controller = Get.find<ActiveSessionsController>();
    return StreamBuilder<List<SessionModel>>(
      stream: controller.fetchActiveSessions(), 
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(color: Colors.blue,),
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
                'No sessions available yet',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),
              ),
              const SizedBox(height: 8,),
              Text(
                'Available sessions will be seen here',
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
            //shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.data!.length ,
            itemBuilder: (context, index) {
              final session = snapshot.data![index];

              return _buildSessionCard(session, isActive: true, context: context);
            },
           );
         }
       );
     }
  

  Widget buildJoinedSessionsStream(){
    final controller = Get.find<ActiveSessionsController>();
    final attendanceController = Get.find<AttendanceController>();
    return Stack(
      children: [
        StreamBuilder<List<Participant>>(
          stream: controller.getJoinedSessions(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(color: Colors.blue,),);
            }
        
            if(!snapshot.hasData || snapshot.data!.isEmpty){
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
        
            return 
            ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final participant = snapshot.data![index];
        
                    //check if joined
                    controller.checkIfJoined(participant.sessionId,participant.studentId);
                    
                    return _buildJoinedSessionCard(participant);
                  },
                );
            }
          ),
          Positioned.fill(
            child: Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: attendanceController.confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.blue, Colors.green, Colors.pink, Colors.yellow,Colors.orange,Colors.purple],
              createParticlePath: (size) {
                return Path()..addOval(Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2));
              },
            ),
          ),
        ),
      ],
    );
    }

  // GetX controller instance
  final AttendanceController attendanceController = Get.find<AttendanceController>();
  final PermissionService _permissionService = PermissionService();

  Future<void> _scanAndMarkAttendance(String currentSessionId) async {
    // 1. Check Camera Permission
    bool hasPermission = await _permissionService.checkCameraPermission();
    if (!hasPermission) {
      hasPermission = await _permissionService.requestCameraPermission();
      if (!hasPermission) {
        attendanceController.message.value = 'Camera permission denied. Cannot scan QR code.';
        Get.snackbar(
          'Permission Required',
          'Please grant camera permission in app settings.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
    }

    // 2. Navigate to Scanner and Await Result
    // Use Get.to() for navigation and await its result
    final String? qrCodeData = await Get.to(() => const QrScannerPage());

    // 3. Process Scanned QR Data and Initiate Biometrics
    if (qrCodeData != null && qrCodeData.isNotEmpty) {
      // Provide immediate feedback to user
      Get.snackbar(
        'QR Scanned!',
        'QR code detected. Initiating biometric check...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blueGrey,
        colorText: Colors.white,
        duration: const Duration(seconds: 2), // Short duration as biometric prompt follows
      );

      // Call the controller method to handle the rest (biometrics + Firestore)
      await attendanceController.markAttendance(
        qrCodeData: qrCodeData,
        currentSessionId: currentSessionId,
      );
    } else {
      attendanceController.message.value = 'QR code scan cancelled or failed.';
      Get.snackbar(
        'Scan Cancelled',
        'No QR code was scanned.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildJoinedSessionCard(Participant participant)  {

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
        .collection('sessions')
        .doc(participant.sessionId)
        .snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return SizedBox.shrink();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final bool isActive = data['isQRActive'] ?? false;

        return Card(
          color: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(
              participant.sessionTitle,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8,),
                Text(
                  participant.sessionDescription,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  'Joined at: ${participant.joinedAt.toString()}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
            trailing: Obx(() => attendanceController.isLoading.value
              ? const Column(
                children: [
                  CircularProgressIndicator(color: Colors.blue,),
                  SizedBox(height: 5),
                  Text('Please wait...'),
                ],
              )
              : ElevatedButton(
                  style: ButtonStyle(
                  backgroundColor: isActive ? WidgetStatePropertyAll(Theme.of(context).colorScheme.primary) : WidgetStatePropertyAll(Colors.grey)
                ),
                onPressed: isActive ? () async => _scanAndMarkAttendance(participant.sessionId) : null,
                child: Text(
                  'Scan QR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                  ),
                )
              ),
            ),
          ),
      );
      },
    );
  }

  Widget _buildSessionCard(SessionModel session, {required bool isActive, required BuildContext context}) {
    final remainingTime = DateTime.now().add(Duration(days: 1)).difference(DateTime.now());//session.joinEndTime!.difference
    final hoursLeft = remainingTime.inHours;
    final minutesLeft = remainingTime.inMinutes;

    return Card(
      color: Colors.white,
      //margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              session.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 8,),
            Text(
              session.description,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 12,),
            Row(
              children: [
                Icon(Icons.access_time_rounded, size: 16,),
                const SizedBox(width: 4,),
                Text(
                  hoursLeft > 1 ?
                  'Closes in $hoursLeft hours': hoursLeft != 0 ?
                  'Closes in $hoursLeft hour' : minutesLeft > 1 ?
                  'Closes in $minutesLeft minutes' : 'Closes in $minutesLeft minute',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16,),
            if(isActive) _buildJoinButton(session, context),
            if(!isActive) _buildJoinedStatus(),
          ],
        ),
      ),
    );
  }

  Widget _buildJoinButton(SessionModel session, BuildContext context){
    final controller = Get.find<ActiveSessionsController>();
    return Obx(() {
      final hasJoined = controller.joinedStatus[session.id] ?? false;
        return ElevatedButton(
          onPressed: hasJoined ? null : () {
            controller.joinSession(session: session);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: hasJoined ? Colors.grey : Theme.of(context).colorScheme.primary
          ),
          child: Text(
            hasJoined ? 'Joined' : 'Join Session',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white
            ),
          ),
        );
    });
  }

  Widget _buildJoinedStatus(){
    return Row(
      children: [
        Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 16,),
        Text(
          'You\'ve joined this session',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.green
          ),
        ),
      ],
    );
  }
}