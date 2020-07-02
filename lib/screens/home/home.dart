
import 'package:bowie/services/auth.dart';
import 'package:bowie/services/square.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'background.dart';
import 'package:bowie/screens/home/about_accfb.dart';
import 'annon_donate.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ACCFB Donation Home',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Montserrat'),
      home: HomePage(),
    );
}
}

class HomePage extends StatelessWidget {

  final String title = "Alameda Community Food Bank Home";
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(children: [
        Background(),
        Center(
          child: DonateButton(),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => AboutACCFB())),
          child: Container(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 60),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(8.0)),
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
        Align(
            alignment: Alignment.topRight,
            child: FlatButton.icon(
              color: Color.fromARGB(255, 0, 167, 181),
              onPressed: _auth.signOut,
              icon: Icon(Icons.settings),
              label: Text("Settings"),
            ))
      ]),
    );
  }
}

//raised button or other button builtin?
class DonateButton extends StatefulWidget {
  const DonateButton({
    Key key,
  }) : super(key: key);

  @override
  _DonateButtonState createState() => _DonateButtonState();
}

class _DonateButtonState extends State<DonateButton> {
  final _auth = AuthService();

  void _donate() async{
    //todo animate
    final _curUser = await _auth.getUser();
    if (_curUser.isAnonymous){
      Navigator.push(context, MaterialPageRoute(builder: (context) => AnonDonate()));
    } else {
      print("non anon user wants to donate");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _donate,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 167, 181),
              borderRadius: BorderRadius.all(Radius.circular(8.0 * 2 + 17))),
          child: Text(
            "Donate Now",
            style: TextStyle(fontSize: 17),
          ),
        ),
      ),
    );
  }
}
