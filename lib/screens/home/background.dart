import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

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
