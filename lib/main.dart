import 'dart:async';

import 'package:bowie/AboutACCFB.dart';
import 'package:bowie/HeroExample.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
      home: MyHomePage(title: 'Alameda Food Bank'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(children: [
        Background(),
        Center(
          child: GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => HeroExample())),
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 167, 181),
                  borderRadius:
                      BorderRadius.all(Radius.circular(8.0 * 2 + 17))),
              child: Text(
                "Donate Now",
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
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
        )
      ]),
    );
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
          opacity: (_opacity-1).abs(),
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
