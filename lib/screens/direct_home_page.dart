import 'package:bowie/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'on_board/add_card.dart';
import 'on_board/authenticate.dart';

class DirectHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<FirebaseUser>(context);
    final _login = Provider.of<LoginAction>(context);

    //if there's no user, no matter what, take us to the login page
    if (_user == null) {
      return Authenticate();
    } else {
      //if we are anon, take us to the home page
      if (_login.anon) {
        return HomePage();
      } else if (_login.login) {
        //if we're logging in take us to the home page
        return HomePage();
      } else if (!_login.login) {
        //if we're not logging in (ie we're signing up)
        if(_login.doneOnBoarding){
          return HomePage();
        } else {
          return AddCard();
        }
      }
    }
    // if all else fails, take us to the login page (this code should never be reached)
    return Authenticate();
  }
}
