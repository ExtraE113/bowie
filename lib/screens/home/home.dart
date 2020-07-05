import 'package:bowie/services/auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'accfb_logo.dart';
import 'donate_button.dart';

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
        Container(color: Theme.of(context).backgroundColor),
        Center(child: DonateButton()),
        Logo(),
      ]),
    );
  }
}
