import 'package:bowie/screens/donate_detail/donate_detail.dart';
import 'package:bowie/screens/on_board/authenticate.dart';
import 'package:bowie/services/auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'accfb_logo.dart';
import 'donate_button.dart';

import 'home_drawer.dart';

class HomePage extends StatelessWidget {
  final String title = "Thank you!";
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    if (Provider.of<LoginAction>(context, listen: false).doneOnBoarding) {
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
    } else {
      return DonateDetail(firstTime: true);
    }
  }
}
