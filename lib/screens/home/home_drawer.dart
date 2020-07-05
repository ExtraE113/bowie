import 'package:bowie/screens/on_board/authenticate.dart';
import 'package:bowie/services/auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key key,
    @required AuthService auth,
  }) : _auth = auth, super(key: key);

  final AuthService _auth;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Container(
              child: Column(
                children: [
                  Spacer(flex: 3),
                  Icon(Icons.account_circle, size: 70),
                  Spacer(),
                  Text("Username"),
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
            splashColor: Theme.of(context).primaryColorLight,
            onPressed: () {},
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
            ),
            color: Colors.grey[50],
          ),
          Divider(),
          RaisedButton(
            splashColor: Theme.of(context).primaryColorLight,
            onPressed: () {},
            child: ListTile(
              leading: Icon(Icons.account_box),
              title: Text("Account"),
            ),
            color: Colors.grey[50],
          ),
          Divider(),
          RaisedButton(
            splashColor: Theme.of(context).primaryColorLight,
            onPressed: () {},
            child: ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text("Payment"),
            ),
            color: Colors.grey[50],
          ),
          Divider(),
          RaisedButton(
            splashColor: Theme.of(context).primaryColorLight,
            onPressed: () {},
            child: ListTile(
              leading: Icon(Icons.email),
              title: Text("Support"),
            ),
            color: Colors.grey[50],
          ),
          Divider(),
          RaisedButton(
            splashColor: Theme.of(context).primaryColorLight,
            onPressed: () {
              _auth
                  .signOut()
                  .then((value) => Provider.of<LoginAction>(context, listen: false).reset());
            },
            child: ListTile(
              title: Text("Logout"),
              leading: Transform.rotate(angle: 3.1415, child: Icon(Icons.exit_to_app)),
            ),
            color: Colors.grey[50],
          )
        ],
      ),
    );
  }
}
