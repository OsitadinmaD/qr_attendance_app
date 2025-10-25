import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentProfilePixInfo extends StatelessWidget {
  const StudentProfilePixInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return Container(
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.height * 0.32,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          spacing: 5,
          children: [
            CircleAvatar(
              radius: 70,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text('A',
                style: TextStyle(
                  fontSize: 70,fontWeight: FontWeight.bold,color: Colors.white
                ),
              ),
            ),
            Text(
              auth.currentUser!.displayName ?? '',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25
              ),
            ),
            Text(
              auth.currentUser!.email ?? '',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                fontSize: 18
              ),
            )
          ],
        ),
      ),
    );
  }
}