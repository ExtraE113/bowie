import 'package:bowie/screens/donate_detail/donate_detail.dart';
import 'package:bowie/screens/on_board/elevator_pitch.dart';
import 'package:bowie/screens/on_board/thank_you.dart';
import 'package:bowie/theme_data.dart';
import 'package:bowie/screens/direct_home_page.dart';
import 'package:bowie/screens/on_board/authenticate.dart';
import 'package:bowie/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() {
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(
      ChangeNotifierProvider(
        create: (BuildContext context) => LoginAction(),
        child: MyApp(),
      ),
    );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: accfbTheme(),
        initialRoute: "/",
        routes: {
          '/': (context) => DirectHomePage(),
          '/carousel': (context) => OnBoardCarousel(),
          '/donate-detail-first': (context) => DonateDetail(firstTime: true),
          '/donate-detail': (context) => DonateDetail(firstTime: false),
          '/auth': (context) => Authenticate(),
          '/thanks': (context) => ThankYou()
        },
      ),
    );
  }
}