import 'dart:async';

import 'package:bowie/screens/donate_detail/donate_amount_chips.dart';
import 'package:bowie/services/cloud_firestore.dart';
import 'package:bowie/services/square.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class DonateButton extends StatefulWidget {
  @override
  _DonateButtonState createState() => _DonateButtonState();
}

class _DonateButtonState extends State<DonateButton> {
  FirestoreService _firestore;
  Stream<Map> _data;

  List _buttonStates = [];

  @override
  void initState() {
    super.initState();
    _firestore = FirestoreService();
    _data = _firestore.getSettingsStream("donate-amount-chips");
//    _data.listen((value) {
//      if (value.length == 0) {
//        Crashlytics.instance.log("Chips length zero | Error code 8634");
//        _showErrorDialog(
//          Text("Something went wrong"),
//          child: Text("That's all we know. \n Error code 8634"),
//        ); //random error code
//      }
//    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _data,
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return CircularProgressIndicator();
            }
            var data = DonationAmountData.fromMap(snapshot.data);
            var cents = data.selectedCents;
            cents.sort((a, b) => a.compareTo(b) * -1); //reverse sort
            for (var _ in cents) {
              _buttonStates.add([Icon(Icons.account_balance_wallet), -1]);
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i in Iterable<int>.generate(cents.length).toList())
                  Row(
                    children: <Widget>[
                      Spacer(),
                      RaisedButton(
                          onPressed: _buttonStates[i][1] == 0
                              ? null
                              : () async {
                                  if (!await _firestore.hasCof()) {
                                    try {
                                      final bool saved = await SquareService().save();
                                      if (saved) {
                                        donateAndUpdateIndicator(i, cents);
                                      }
                                    } catch (e, st) {
                                      //random error code
                                      Crashlytics.instance
                                          .log("Error code 9206");
                                      Crashlytics.instance.recordError(e, st);
                                      Crashlytics.instance.log(
                                          "Something went wrong. | Error code 9206");
                                      _showErrorDialog(
                                        Text("Something went wrong"),
                                        child: Text(
                                            "That's all we know. \n Error code 9206"),
                                      );
                                    }
                                  } else {
                                    donateAndUpdateIndicator(i, cents);
                                  }
                                },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                _buttonStates[i][0],
                                SizedBox(width: 10),
                                Text(
                                  "${ChipData(cents[i])}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(fontSize: 20),
                                ),
                              ],
                            ),
                          )),
                      Spacer(),
                    ],
                  )
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  void donateAndUpdateIndicator(int i, List<int> cents) {
    setState(() {
      _buttonStates[i][1] = 0;
      _buttonStates[i][0] = CircularProgressIndicator();
    });
    SquareService().pay(true, cents[i]).then((value) {
      if (value == true) {
        setState(() {
          _buttonStates[i][1] = -1;
          _buttonStates[i][0] = Icon(Icons.check);
        });
      }
    }).catchError((error) {
      _showErrorDialog(Text("Unable to contact the servers."),
          child: Text(
              "Your device may be offline. If the problem persists, please contact technical support."));
      setState(() {
        _buttonStates[i][1] = -1;
        _buttonStates[i][0] = Icon(Icons.cancel);
      });
      return null;
    }, test: (e) => e is TimeoutException).catchError((error) {
      setState(() {
        _buttonStates[i][1] = -1;
        _buttonStates[i][0] = Icon(Icons.cancel);
      });

      _showErrorDialog(Text(error.toString()));
      return null;
    }).whenComplete(() => Future.delayed(Duration(seconds: 2)).then((value) {
          setState(() {
            _buttonStates[i][1] = -1;
            _buttonStates[i][0] = Icon(Icons.account_balance_wallet);
          });
        }));
  }

  Future<void> _showErrorDialog(Widget title,
      {Widget child, List<Widget> actions}) async {
    if (actions == null) {
      actions = <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ];
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          content: SingleChildScrollView(
            child: child,
          ),
          actions: actions,
        );
      },
    );
  }
}
