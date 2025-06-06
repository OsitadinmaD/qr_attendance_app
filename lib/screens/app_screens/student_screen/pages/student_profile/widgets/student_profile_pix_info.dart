import 'package:flutter/material.dart';

class StudentProfilePixInfo extends StatelessWidget {
  const StudentProfilePixInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              backgroundColor: Colors.blue.shade300,
              child: Text('A',
                style: TextStyle(
                  fontSize: 70,fontWeight: FontWeight.bold,color: Colors.white
                ),
              ),
            ),
            Text(
              'Ositadinma Divine Akachukwu',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 35
              ),
            ),
            Text(
              'akindivine512@gmail.com',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                fontSize: 22
              ),
            )
          ],
        ),
      ),
    );
  }
}