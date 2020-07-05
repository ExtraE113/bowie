import 'package:bowie/screens/on_board/authenticate.dart';
import 'package:bowie/services/cloud_firestore.dart';
import 'package:bowie/services/square.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a card"),
      ),
      body: AddCardButton(),
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
          RaisedButton(
            onPressed: () {
              Provider.of<LoginAction>(context, listen: false).doneOnBoarding = true;
            },
            child: Text("Set up later"),
          ),
          RaisedButton(
            onPressed: () async {
              print(await FirestoreService().hasCof());
            },
            child: Text("test"),
          )
        ],
      ),
    );
  }
}
