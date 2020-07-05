import 'package:bowie/screens/on_board/authenticate.dart';
import 'package:bowie/services/auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'DonateButton.dart';
import 'package:bowie/screens/home/about_accfb.dart';

class HomePage extends StatelessWidget {
  final String title = "Thank you!";
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: Drawer(
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
            Card(
              child: InkWell(
                splashColor: Theme.of(context).primaryColorLight,
                onTap: () {},
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text("Settings"),
                ),
              ),
            ),
            Card(
              child: InkWell(
                splashColor: Theme.of(context).primaryColorLight,
                onTap: () {},
                child: ListTile(
                  leading: Icon(Icons.account_box),
                  title: Text("Account"),
                ),
              ),
            ),
            Card(
              child: InkWell(
                splashColor: Theme.of(context).primaryColorLight,
                onTap: () {},
                child: ListTile(
                  leading: Icon(Icons.account_balance_wallet),
                  title: Text("Payment"),
                ),
              ),
            ),
            Card(
              child: InkWell(
                splashColor: Theme.of(context).primaryColorLight,
                onTap: () {},
                child: ListTile(
                  leading: Icon(Icons.email),
                  title: Text("Support"),
                ),
              ),
            ),
            Card(
              child: InkWell(
                splashColor: Theme.of(context).primaryColorLight,
                onTap: () {
                  _auth
                      .signOut()
                      .then((value) => Provider.of<LoginAction>(context, listen: false).reset());
                },
                child: ListTile(
                  title: Text("Logout"),
                  leading: Transform.rotate(angle: 3.1415, child: Icon(Icons.exit_to_app)),
                ),
              ),
            )
          ],
        ),
      ),
      body: Stack(children: [
        Container(
          color: Theme.of(context).backgroundColor,
        ),
        Center(
          child: DonateButton(),
        ),
        GestureDetector(
          onTap: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) => AboutACCFB())),
          child: Container(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 60),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(8.0)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(//todo local image
                      "https://www.accfb.org/wp-content/uploads/2017/07/ACCFB_Logo_Header_RGB_506x122.png"),
                ),
              ),
            ),
            alignment: Alignment.topLeft,
          ),
        ),
      ]),
    );
  }
}
