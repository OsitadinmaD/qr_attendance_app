
import 'package:flutter/material.dart';

class ProfileMenuItems extends StatelessWidget {
  const ProfileMenuItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(20),
            boxShadow: List.filled(1, BoxShadow(color: Colors.black38,blurRadius: 1,spreadRadius: 0.5))
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ListTile(
                  title: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,size: 28,),
                ),
                Divider(color: Colors.grey,height: 0.5,),
                ListTile(
                  title: Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,size: 28,),
                ),
                Divider(color: Colors.grey,height: 0.5,),
                ListTile(
                  title: Text(
                    'Light/Dark Mode',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,size: 28,),
                ),
                Divider(color: Colors.grey,height: 0.5,),
                ListTile(
                  title: Text(
                    'FeedBack',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,size: 28,),
                ),
                Divider(color: Colors.grey,height: 0.5,),
                ListTile(
                  title: Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,size: 28,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}