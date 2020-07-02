import 'package:bowie/services/square.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add a card',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Montserrat'),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Add a card"),
        ),
        body: AddCardButton(),
      ),
    );
  }
}

class AddCardButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          RaisedButton(
            onPressed: () {
              save();
            },
            child: Text("Add a card for faster donations"),
          ),
//          RaisedButton(
//            onPressed: () {
//              _pushNext(context);
//            },
//            child: Text("Set up later"),
//          ),
        ],
      ),
    );
  }
}
