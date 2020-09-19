import 'package:flutter/material.dart';
import 'package:flutter_placeholder_textlines/flutter_placeholder_textlines.dart';

class CardInfo extends StatelessWidget {

  String last4;
  int expYear;
  int expMonth;
  String cardBrand;
  Key key;
  bool loading = false;


  CardInfo(Map<String, dynamic> map){
    this.last4 = map["last_4"];
    this.expYear = map["exp_year"];
    this.expMonth = map["exp_month"];
    this.cardBrand = map["card_brand"];
    this.key = ValueKey("$last4$expYear$expMonth$cardBrand$loading");
    //probably a better key to use, but because it's only created once when the widget is generated it doesn't matter.
  }

  CardInfo.loading(){
    this.loading = true;
    this.last4 = "";
    this.expYear = -1;
    this.expMonth = -1;
    this.cardBrand = "";
    //Is this code duplication? yes. does it make sense for both of these to inherit from a parent constructor? no.
    this.key = ValueKey("$last4$expYear$expMonth$cardBrand$loading");
    //probably a better key to use, but because it's only created once when the widget is generated it doesn't matter.
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.account_balance_wallet),
      trailing: Icon(Icons.reorder),
      title: !loading ? Text("**** **** **** ${this.last4}") : PlaceholderLines(count: 1),
      subtitle: Row(
        children: [
          !loading ? Text(this.cardBrand) : Container(width: 90,child: PlaceholderLines(count: 1)),
          Spacer(flex: 3),
          !loading ? Text("${this.expMonth}/${this.expYear}") : Container(width: 90,child: PlaceholderLines(count: 1)),
          Spacer(flex: 4)
        ],
      ),
    );
  }
}
