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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

  AnimationController controller;
  Animation<double> animation;
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _image = 0;

  void _incrementImage() {
    setState(() {
      if (_image % 2 == 0) {
        backgroundFadeOutController.forward();
        backgroundFadeInController.forward();

        kbController2.forward();
      } else {
        backgroundFadeOutController.reverse();
        backgroundFadeInController.reverse();

        kbController1.forward();
      }
      _image += 3; //todo randomize
    });
  }

  //manages fading out after the kb effect is over
  AnimationController backgroundFadeOutController;
  Animation<double> backgroundFadeOutAnimation;

  //manages fading in new image after the kb effect is over
  AnimationController backgroundFadeInController;
  Animation<double> backgroundFadeInAnimation;

  //manages kb effect for first, third, etc image
  AnimationController kbController1;
  Animation<double> kbAnimation1;

  //manages kb effect for second, fourth, etc image
  AnimationController kbController2;
  Animation<double> kbAnimation2;

  var img1 = 'assets/kb/kb0.jpg';
  var img2 = 'assets/kb/kb1.jpg';

  @override
  initState() {
    super.initState();

    //manages fading out after the kb effect is over
    // (sorta, switches roles every other)
    backgroundFadeOutController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    backgroundFadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(backgroundFadeOutController);

    //manages fading in new image after the kb effect is over
    // (sorta, switches roles every other)
    backgroundFadeInController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    backgroundFadeInAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(backgroundFadeInController);

    //manages kb effect for first, third, etc image

    var ar1 = false;
    kbController1 =
        AnimationController(duration: const Duration(seconds: 30), vsync: this);
    kbAnimation1 = Tween<double>(begin: -1.0, end: 1.0).animate(kbController1)
      ..addListener(() {
        //not sure why we need the kbController1.lastElapsedDuration != null but it prevents an error so I don't ask questions
        if (kbController1.lastElapsedDuration != null &&
            kbController1.lastElapsedDuration > Duration(seconds: 30 - 3) &&
            !ar1) {
          ar1 = true;
          _incrementImage();
        }
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          kbController1.reset();
          ar1 = false;
          setState(() {
            img1 = 'assets/kb/kb${_image % 16}.jpg';
          });
        }
      });

    //manages kb effect for second, fourth, etc image
    var ar2 = false;
    kbController2 =
        AnimationController(duration: const Duration(seconds: 30), vsync: this);
    kbAnimation2 = Tween<double>(begin: -1.0, end: 1.0).animate(kbController2)
      ..addListener(() {
        //not sure why we need the kbController1.lastElapsedDuration != null but it prevents an error so I don't ask questions
        if (kbController2.lastElapsedDuration != null &&
            kbController2.lastElapsedDuration > Duration(seconds: 30 - 3) &&
            !ar2) {
          ar2 = true;
          _incrementImage();
        }
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          kbController2.reset();
          ar2 = false;
          setState(() {
            img2 = 'assets/kb/kb${(_image + 1) % 16}.jpg';
          });
        }
      });

    kbController1.forward();
  } //todo dispose

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(children: [
        FadeTransition(
            opacity: backgroundFadeOutAnimation, child: buildKenBurns1(img1)),
        //todo fixme this is ugly and not extensible and ughhh but it works for now
        FadeTransition(
            opacity: backgroundFadeInAnimation, child: buildKenBurns2(img2)),
        Center(
          child: GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => HeroExample())),
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 167, 181),
                  borderRadius: BorderRadius.all(Radius.circular(8.0*2+17))),
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
        )
      ]),
    );
  }

  buildKenBurns1(String asset) {
    return AnimatedBuilder(
      builder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(asset),
                fit: BoxFit.cover,
                alignment: Alignment(kbAnimation1.value, kbAnimation1.value)),
          ),
        );
      },
      animation: kbAnimation1,
    );
  }

  buildKenBurns2(String asset) {
    return AnimatedBuilder(
      builder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(asset),
                fit: BoxFit.cover,
                alignment: Alignment(kbAnimation2.value, kbAnimation2.value)),
          ),
        );
      },
      animation: kbAnimation2,
    );
  }
}
