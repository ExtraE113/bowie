import 'package:bowie/screens/on_board/authenticate.dart';
import 'package:bowie/services/square.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            onPressed: () async {
              final _square = SquareService();
              final bool saved = await _square.save();
              if (saved == true){
                Provider.of<LoginAction>(context, listen: false).doneOnBoarding = true;
              }
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
