import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/screens/app_screens/student_screen/pages/student_profile/controllers/edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());
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
          'Edit Profile',
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
                'Name',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5,),
              TextField(
                controller: controller.nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Name',
                  focusColor: Colors.black,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),borderSide: BorderSide(color: Colors.black,))
                ),
              ),
              SizedBox(height: 15,),
              Text(
                'Matric Number',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5,),
              TextField(
                controller: controller.matricNumberController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Matric Number',
                  focusColor: Colors.black,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),borderSide: BorderSide(color: Colors.black))
                ),
              ),
              const SizedBox(height: 15,),
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
                controller: controller.departmentController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Microbiology',
                  focusColor: Colors.black,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),borderSide: BorderSide(color: Colors.black,))
                ),
              ),
              SizedBox(height: 15,),
              SizedBox(
                width: Get.width,
                child: Obx(() => ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: controller.isLoading.value ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor),
                    onPressed: controller.isLoading.value ? null : () async => await controller.updateProfile(),
                    label: controller.isLoading.value ?
                      Text(
                        'Please wait...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ) : 
                      Text(
                        'Update',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      icon: controller.isLoading.value ? CircularProgressIndicator(color: Colors.white,) : Icon( Icons.update_rounded,size: 20,color: Colors.white,),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}