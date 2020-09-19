import 'dart:async';

import 'package:bowie/screens/home/home.dart';
import 'package:bowie/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'donate_detail/donate_detail.dart';
import 'on_board/authenticate.dart';

class DirectHomePage extends StatefulWidget {
  @override
  _DirectHomePageState createState() => _DirectHomePageState();
}

class _DirectHomePageState extends State<DirectHomePage> {
  StreamSubscription _subscription;

  @override
  void initState() {
    final stream = AuthService().user;
    _subscription = stream.listen(
      (event) {
        if (event == null) {
          Navigator.of(context).pushNamedAndRemoveUntil('/carousel', (route) => false);
        }
      },
      cancelOnError: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginAction>(builder: (BuildContext context, LoginAction value, Widget child) {
      if (value.doneOnBoarding) {
        return HomePage();
      } else {
        return DonateDetail(firstTime: true);
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
