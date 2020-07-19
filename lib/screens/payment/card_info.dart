import 'package:flutter/material.dart';
import 'package:flutter_placeholder_textlines/flutter_placeholder_textlines.dart';

class CardInfo extends StatelessWidget {

  String last4;
  int expYear;
  int expMonth;
  String cardBrand;
  bool loading = false;

  CardInfo.individual(this.last4, this.expYear, this.expMonth, this.cardBrand);


  CardInfo(Map<String, dynamic> map){
    this.last4 = map["last_4"];
    this.expYear = map["exp_year"];
    this.expMonth = map["exp_month"];
    this.cardBrand = map["card_brand"];
  }

  CardInfo.loading(){
    this.loading = true;
    this.last4 = "";
    this.expYear = -1;
    this.expMonth = -1;
    this.cardBrand = "";
  }

  @override
  Widget build(BuildContext context) {
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
        leading: Icon(Icons.account_balance_wallet),
        title: !loading ? Text("**** **** **** ${this.last4}") : PlaceholderLines(count: 1),
        subtitle: Row(
          children: [
            !loading ? Text(this.cardBrand) : Container(width: 90,child: PlaceholderLines(count: 1)),
            Spacer(flex: 3),
            !loading ? Text("${this.expMonth}/${this.expYear}") : Container(width: 90,child: PlaceholderLines(count: 1)),
            Spacer(flex: 4)
          ],
        ),
      ),
    );
  }
}
