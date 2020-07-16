import 'package:bowie/screens/direct_home_page.dart';
import 'package:flutter/material.dart';

class ThankYou extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thank you"),
      ),
      body: ListTile(
        title: Padding(
          child: Text("Thank you for taking the time to set up this app."),
          padding: EdgeInsets.symmetric(vertical: 2.0),
        ),
        subtitle: Text("You'll never have to go through that settings process again."),
      ),
    );
  }
}
