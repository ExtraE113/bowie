import 'package:bowie/screens/payment/card_info.dart';
import 'package:bowie/services/cloud_firestore.dart';
import 'package:bowie/services/square.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class PaymentInformation extends StatefulWidget {
  @override
  _PaymentInformationState createState() => _PaymentInformationState();
}

class _PaymentInformationState extends State<PaymentInformation> {
  FirestoreService _firestore;
  List _cards;
  Icon _fabIcon = Icon(Icons.add);
  Future<String> _initialDefaultCard;

  @override
  void initState() {
    super.initState();
    _firestore = FirestoreService();
    _initialDefaultCard = _firestore.getDefaultCard();
    _firestore.getCards().then((value) async {
      print("24");
      String _idc = await _initialDefaultCard;
      setState(() {
        _cards = List();
        value.sort((a, b) {
          if (a["id"] == _idc) return -100;
          if (b["id"] == _idc) return 100;
          return 0;
        });
        _cards.addAll(value);
      });
    }).catchError((e, st) {
      Crashlytics.instance.recordError(e, st);
      _showErrorDialog(Text("Something went wrong."),
          child: Text("That's all we know."));
    });
    _firestore.getCardsStream().listen((event) async {
      //ugly but works
      while (_cards == null) await Future.delayed(Duration(milliseconds: 250));
      setState(() {
        _cards.insert(0, event);
      });
      _firestore.setDefaultCard(event["id"]);
    }).onError((e, st) {
      Crashlytics.instance.recordError(e, st);
      _showErrorDialog(Text("Something went wrong."),
          child: Text("That's all we know."));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment information"),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              final bool saved = await SquareService().save();
              if (saved) {
                setState(() {
                  _fabIcon = Icon(Icons.check);
                });
              }
            } catch (e, st) {
              Crashlytics.instance.recordError(e, st);
              setState(() {
                _fabIcon = Icon(Icons.cancel);
              });
              showDialog(
                  context: context,
                  child: SimpleDialog(
                    title: Text("Something went wrong"),
                    children: [
                      SimpleDialogOption(
                        child: Text("OK"),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  ));
            } finally {
              Future.delayed(Duration(seconds: 5)).then((value) {
                setState(() {
                  _fabIcon = Icon(Icons.add);
                });
              });
            }
          },
          child: _fabIcon),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: ReorderableListView(
              header: ListTile(
                title: Container(
                  padding: EdgeInsets.only(bottom: 3),
                  child: Text(
                    "Payment information",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                subtitle: Text(
                    "Review or add payment information. \nThe top card is the default payment method. Drag and drop to reorder."),
              ),
              onReorder: (int oldIndex, int newIndex) {
                var item;
                setState(
                  () {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    item = _cards.removeAt(oldIndex);
                    _cards.insert(newIndex, item);
                  },
                );
                if (newIndex == 0) {
                  _firestore.setDefaultCard(item["id"]);
                }
              },
              children: [
                if (_cards != null) for (var i in _cards) CardInfo(i),
                if (_cards == null) CardInfo.loading()
              ],
            ),
          ),
        ),
      ),
    );
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
