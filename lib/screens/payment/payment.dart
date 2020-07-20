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
  Future<List> _data;
  Icon _fabIcon = Icon(Icons.add);

  @override
  void initState() {
    super.initState();
    _firestore = FirestoreService();
    _data = _firestore.getCards();
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
                  _data = _firestore.getCards();
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
          child: ListView(
            physics: ClampingScrollPhysics(),
            children: [
              ListTile(
                title: Container(
                  padding: EdgeInsets.only(bottom: 3),
                  child: Text(
                    "Payment information",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                subtitle:
                    Text("Review, add, or delete payment information."),
              ),
              FutureBuilder(
                future: _data,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (Map<String, dynamic> i in snapshot.data) CardInfo(i),
                      ],
                    );
                  } else {
                    return Column(
                      children: [CardInfo.loading()],
                    );
                  }
                },
              ),
            ],
          ),
          color: Theme.of(context).backgroundColor,
        ),
      ),
    );
  }
}
