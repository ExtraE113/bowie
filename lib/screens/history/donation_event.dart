import 'package:bowie/utils/util_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_placeholder_textlines/flutter_placeholder_textlines.dart';

class DonationEvent extends StatelessWidget {

  Map<String, dynamic> data;
  bool loading = false;


  DonationEvent(this.data);

  DonationEvent.loading(){
    this.loading = true;
    this.data = Map();
  }

  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch((this.data["time"] as Timestamp).millisecondsSinceEpoch);

    data["formatted_time"] = "${time.year}-${time.month}-${time.day}";

    return Dismissible(
      onDismissed: (_){}, //TODO implement
      background: Container(
        color: Colors.red,
        child: Row(
          children: [
            Spacer(flex: 5),
            Icon(Icons.delete_forever),
            Spacer()
          ],
        ),
      ),
      direction: DismissDirection.endToStart,
      key: UniqueKey(),
      child: ListTile(
        leading: Icon(Icons.card_giftcard),
        title: !loading ? Text("${UtilFunction.centsToDollarsRepresentation(this.data["payment"]["total_money"]["amount"][0])}") : PlaceholderLines(count: 1),
        subtitle: Row(
          children: [
            !loading ? Text("**** **** **** ${this.data["payment"]["card_details"]["card"]["last_4"]}") : PlaceholderLines(count: 1),
            Spacer(flex: 3),
            !loading ? Text(data["formatted_time"]) : Container(width: 90,child: PlaceholderLines(count: 1)),
            Spacer(flex: 4)
          ],
        ),
      ),
    );
  }
}
