import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/constants/helpers/snackbar_message_show.dart';
import 'package:qr_attendance_app/screens/app_screens/student_screen/pages/student_profile/controllers/feedback_controllers.dart';


class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FeedbackControllers());
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          tooltip: 'back',
          onPressed: () => Get.back(), 
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 25,)
        ),
        title: Text(
          'Feedback',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                softWrap: true,
                textAlign: TextAlign.center,
                'Your feedback will be much appreciated as it will help us improve the system and render optimal services',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 5,),
              Text(
                'Title',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5,),
              TextField(
                controller: controller.titleController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Possible Improvements',
                  focusColor: Colors.black,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),borderSide: BorderSide(color: Colors.black,))
                ),
              ),
              const SizedBox(height: 15,),
              Text(
                'Comments',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5,),
              TextField(
                controller: controller.commentsController,
                maxLines: 5,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Comments',
                  focusColor: Colors.black,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),borderSide: BorderSide(color: Colors.black))
                ),
              ),
              const SizedBox(height: 15,),
              SizedBox(
                  width: Get.width,
                  child: Obx( () => ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: controller.isLoading.value ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor),
                      onPressed: controller.isLoading.value ? null : () async {
                        if(controller.commentsController.text.isNotEmpty){
                          await controller.uploadFeedback();
                        }else{
                          SnackbarMessageShow.infoSnack(title: 'Empty Field', message: 'The comments should not be empty',);
                        }
                      },
                      label: controller.isLoading.value ?
                        Text(
                          'Sending...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ) :
                        Text(
                          'Send feedback',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      icon: controller.isLoading.value ? CircularProgressIndicator(color: Colors.white,) 
                        : Icon(Icons.feedback_rounded,size: 20,color: Colors.white,),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}