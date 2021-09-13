import 'package:flutter/material.dart';

class Colours {
  static const Color white = Color(0xFFF4F6F6);
  static const Color grey = Color(0xAAAAAAAA);
  static const Color lightBlue = Color(0xFFA0E3DD);
  static const Color darkBlue = Color(0xFF00838F);
  static const Color fadedDarkBlue = Color(0x9900838F);
  static const Color black = Color(0xFF3C3C3C);
  static const Color highlight = Color(0xFFFF9470);
}

class AppTheme {
  AppTheme._();

  static final ThemeData theme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colours.lightBlue,
    backgroundColor: Colours.white,
    fontFamily: 'Sohne-Buch',
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 32,
        height: 1,
      ),
      headline2: TextStyle(
        fontSize: 24,
        height: 1,
      ),
      headline3: TextStyle(
        fontSize: 18,
        height: 1,
      ),
      headline4: TextStyle(
        fontSize: 16,
        height: 1,
      ),
      bodyText1: TextStyle(
        fontSize: 16,
        height: 1.50,
      ),
      bodyText2: TextStyle(
        fontSize: 14,
        height: 1.50,
      ),
      subtitle1: TextStyle(),
      subtitle2: TextStyle(),
    ).apply(
      bodyColor: Colours.black,
      displayColor: Colours.black,
    ),
  );
}
