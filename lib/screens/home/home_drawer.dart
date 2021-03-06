import 'package:bowie/screens/donate_detail/donate_detail.dart';
import 'package:bowie/screens/history/history.dart';
import 'package:bowie/screens/on_board/authenticate.dart';
import 'package:bowie/screens/payment/payment.dart';
import 'package:bowie/services/auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key key,
    @required AuthService auth,
  })  : _auth = auth,
        super(key: key);

  final AuthService _auth;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          DrawerHeader(
            child: Container(
              child: Column(
                children: [
                  Spacer(flex: 3),
                  Icon(Icons.account_circle, size: 70),
                  Spacer(),
                  FutureBuilder(
                    future: _auth.getUser(),
                    builder: (BuildContext context, data) =>
                        Text(data.hasData ? data.data.email : "Username"),
                  ),
                  Spacer(flex: 3),
                ],
              ),
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryVariant,
            ])),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DonateDetail(firstTime: false)));
            },
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
            ),
            color: Colors.grey[50],
          ),
          Divider(),
          RaisedButton(
            child: ListTile(
              leading: Icon(Icons.history),
              title: Text("History"),
            ),
            color: Colors.grey[50],
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => History()));
            },
          ),
          Divider(),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaymentInformation()));
            },
            child: ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text("Payment"),
            ),
            color: Colors.grey[50],
          ),
          Divider(),
          RaisedButton(
            onPressed: () {},
            child: ListTile(
              leading: Icon(Icons.email),
              title: Text("Support"),
            ),
            color: Colors.grey[50],
          ),
          Divider(),
          RaisedButton(
            onPressed: () {
              _auth.signOut().then((value) =>
                  Provider.of<LoginAction>(context, listen: false).reset());
            },
            child: ListTile(
              title: Text("Logout"),
              leading: Transform.rotate(
                  angle: 3.1415, child: Icon(Icons.exit_to_app)),
            ),
            color: Colors.grey[50],
          )
        ],
      ),
    );
  }
}
