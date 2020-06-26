import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bowie/screens/home/home.dart';
import 'package:bowie/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';



class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<FirebaseUser>(context);

    print(user);

    //return either home or authenticate

    return (user == null)? Authenticate() : HomePage(title: 'Alameda Community Food Bank',);
  }
}
