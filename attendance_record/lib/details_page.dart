import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final String userName;
  final String phoneNumber;
  final String formattedDate;

  DetailsPage({required this.userName, required this.phoneNumber, required this.formattedDate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('User: $userName', style: TextStyle(fontSize: 18)),
            Text('Phone Number: $phoneNumber', style: TextStyle(fontSize: 18)),
            Text('Date: $formattedDate', style: TextStyle(fontSize: 18)),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
