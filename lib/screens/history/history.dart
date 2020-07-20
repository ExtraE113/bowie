import 'package:bowie/screens/history/donation_event.dart';
import 'package:bowie/services/cloud_firestore.dart';
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
                    "Donation",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                subtitle:
                Text("Review all your previous donations"),
              ),
              FutureBuilder(
                future: _data,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List sorted = snapshot.data;
                    sorted.sort((a, b) {
                      return (a["time"].compareTo(b["time"]) *-1); //sort newest to oldest
                    });
                    return Column(
                      children: [
                        for (Map<String, dynamic> i in sorted) DonationEvent(i),
                      ],
                    );
                  } else {
                    return Column(
                      children: [DonationEvent.loading()],
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
