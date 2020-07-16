import 'package:bowie/screens/donate_detail/donate_amount_chips.dart';
import 'package:bowie/services/cloud_firestore.dart';
import 'package:bowie/services/square.dart';
import 'package:flutter/material.dart';

class DonateButton extends StatefulWidget {
  @override
  _DonateButtonState createState() => _DonateButtonState();
}

class _DonateButtonState extends State<DonateButton> {
  SquareService _square;
  FirestoreService _firestore;
  Future<Map> _data;

  List _buttonStates = [];

  @override
  void initState() {
    super.initState();
    _firestore = FirestoreService();
    _data = _firestore.getSettings("donate-amount-chips");
    _square = SquareService();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _data,
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return CircularProgressIndicator();
            }
            var data = DonationAmountData.fromMap(snapshot.data);
            var cents = data.selectedCents;
            cents.sort((a, b) => a.compareTo(b)*-1); //reverse sort
            for (var i in cents) {
              _buttonStates.add(-1);
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i in Iterable<int>.generate(cents.length)
                    .toList())
                  Row(
                    children: <Widget>[
                      Spacer(),
                      RaisedButton(
                          onPressed: _buttonStates[i] == 0 ? null : () {
                            setState(() {
                              _buttonStates[i] = 0;
                            });
                            _square.pay(true, cents[i]).then((value) {
                              if (value == true) {
                                setState(() {
                                  _buttonStates[i] = 1;
                                });
                                Future.delayed(Duration(seconds: 2)).then((value) {
                                  setState(() {
                                   _buttonStates[i] =-1;
                                  });
                                });
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                if (_buttonStates[i] == 0)
                                  Row(
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(width: 32.0),

                                    ],
                                  )
                                else if (_buttonStates[i] == 1)
                                  Icon(Icons.check),
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
}
