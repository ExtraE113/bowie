import 'package:bowie/screens/history/donation_event.dart';
import 'package:bowie/services/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  FirestoreService _firestore;
  Future<List> _data;

  @override
  void initState() {
    super.initState();
    _firestore = FirestoreService();
    _data = _firestore.getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donation history"),
      ),
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
                    "Donation history",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                subtitle: Text(
                    "Review your generous contributions. \n This also serves as your receipt."),
              ),
              FutureBuilder(
                future: _data,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List events = snapshot.data;
                    events.sort((a, b) => (a["time"].compareTo(b["time"])*-1)); //reverse sort newest to oldest
                    print(snapshot.data);
                    return Column(
                      children: [
                        for (Map<String, dynamic> i in events)
                          DonationEvent(i),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    Future.delayed(Duration(milliseconds: 500)).then((_) =>
                        _showErrorDialog(
                          Text("Something went wrong."),
                          child: Text("That's all we know. Error code 6489."),
                        )
                    );
                    Crashlytics.instance
                        .log("Error code 9206");
                    Crashlytics.instance.log(snapshot.error.toString());
                  }
                  return Column(
                    children: [DonationEvent.loading()],
                  );
                },
              ),
            ],
          ),
          color: Theme.of(context).backgroundColor,
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