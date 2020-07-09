import 'package:bowie/screens/home/donate_detail/donate_detail.dart';
import 'package:bowie/screens/theme_data.dart';
import 'package:bowie/screens/direct_home_page.dart';
import 'package:bowie/screens/on_board/authenticate.dart';
import 'package:bowie/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (BuildContext context) => LoginAction(),
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {

  final bool debug = false;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: accfbTheme(),
        home: debug ? DonateDetail(firstTime: true,) : DirectHomePage(),
      ),
    );
  }
}
