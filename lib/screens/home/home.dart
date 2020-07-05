import 'package:bowie/services/auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'donate_button.dart';
import 'package:bowie/screens/home/about_accfb.dart';

import 'home_drawer.dart';

class HomePage extends StatelessWidget {
  final String title = "Thank you!";
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: HomeDrawer(auth: _auth),
      body: Stack(children: [
        Container(
          color: Theme.of(context).backgroundColor,
        ),
        Center(
          child: DonateButton(),
        ),
        GestureDetector(
          onTap: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) => AboutACCFB())),
          child: Container(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 60),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(8.0)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(//todo local image
                      "https://www.accfb.org/wp-content/uploads/2017/07/ACCFB_Logo_Header_RGB_506x122.png"),
                ),
              ),
            ),
            alignment: Alignment.topLeft,
          ),
        ),
      ]),
    );
  }
}

