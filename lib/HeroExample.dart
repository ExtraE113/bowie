import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//todo refactor
//todo fixme
//todo implement
class HeroExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donate"),
      ),
      body: Center(
        child: Hero(
          tag: 'donate-btn',
          child: ClipOval(
            child: Container(
                color: Color.fromARGB(255, 0, 167, 181),
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth:
                        300 //fixme dynamic resize based on the amount of space the text widget needs
                    ),
                    child: AspectRatio(
                        aspectRatio: 1,
                        child: Center(
                            child: Text(
                              "Donate Now",
                              style: TextStyle(fontSize: 17),
                            ))))),
          ),
        ),
      ),
    );
  }
}