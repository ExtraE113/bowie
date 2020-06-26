import 'dart:async';
import 'dart:convert';

import 'package:bowie/screens/home/about_accfb.dart';
import 'package:bowie/services/auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';

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
      home: HomePage(title: 'Alameda Food Bank'),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;
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
                icon: Icon(Icons.settings), label: Text("Settings"),)
        )
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
  @override
  void initState() {
    InAppPayments.setSquareApplicationId(
        "sandbox-sq0idb-u0xVRfqSvIDBU-2qw__JEQ");
    super.initState();
  }

  void _pay() {
    InAppPayments.startCardEntryFlow(
      onCardNonceRequestSuccess: _onCardNonceRequestSuccess,
      onCardEntryCancel: _onCardEntryCancel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pay,
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

  void _onCardNonceRequestSuccess(CardDetails result) async {
    print(result.nonce);

    try {
      print("here");

      // set up POST request arguments
      String url = 'https://donate-app-accfb.herokuapp.com/chargeForCookie';
      Map<String, String> headers = {"Content-type": "application/json"};
      String json = '{ "nonce": "${result.nonce}" }'; // make POST request
      Response response = await post(url, headers: headers, body: json);
      // check the status code for the result
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        //todo test
        throw Exception(response);
      }
      InAppPayments.completeCardEntry(
        onCardEntryComplete: _onCardEntryComplete,
      );
    } catch (e) {
      print("here");
      InAppPayments.showCardNonceProcessingError(
          jsonDecode(e.message.body)["errorMessage"]); //todo test
    }
  }

  void _onCardEntryCancel() {}

  void _onCardEntryComplete() {
    // Success
  }
}

class Background extends StatefulWidget {
  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  Timer timer;
  var _opacity;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 10), _updateBackgroundImages);
    _opacity = 0.0;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _updateBackgroundImages(Timer timer) {
    //todo rather than just alternate opacity
    //  could go through a whole list of things
    //  where each one is an action
    setState(() {
      _opacity == 0.0 ? _opacity = 1.0 : _opacity = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(seconds: 1),
          child: ImageBackground(
            image: AssetImage("assets/kb/kb0.jpg"),
          ),
        ),
        AnimatedOpacity(
          opacity: (_opacity - 1).abs(),
          duration: Duration(seconds: 1),
          child: ImageBackground(
            image: AssetImage("assets/kb/kb1.jpg"),
          ),
        )
      ],
    );
  }
}

class ImageBackground extends StatelessWidget {
  var image;

  ImageBackground({
    Key key,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: image, fit: BoxFit.cover)),
    );
  }
}
