import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Map<int, Color> colorCodes = {
  //remember to change square when changing color
  50: Color.fromRGBO(234, 118, 0, .1),
  100: Color.fromRGBO(234, 118, 0, .2),
  200: Color.fromRGBO(234, 118, 0, .3),
  300: Color.fromRGBO(234, 118, 0, .4),
  400: Color.fromRGBO(234, 118, 0, .5),
  500: Color.fromRGBO(234, 118, 0, .6),
  600: Color.fromRGBO(234, 118, 0, .7),
  700: Color.fromRGBO(234, 118, 0, .8),
  800: Color.fromRGBO(234, 118, 0, .9),
  900: Color.fromRGBO(234, 118, 0, 1),
};

ThemeData accfbTheme() {
  final MaterialColor primary = MaterialColor(0xFFEA7600, colorCodes);
//  colorCodes.forEach((key, value) {
//    print("[$key] ${value.value.toRadixString(16)}");
//  });
  return ThemeData(
    primarySwatch: primary,
    splashColor: primary[50],
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Montserrat',
    backgroundColor: primary[200],
    appBarTheme: AppBarTheme(color: primary[800]),
  ).copyWith(backgroundColor: Colors.white);
}
