import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  accentColor: Color(0xff0195f7),
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: kColorPrimary,
  primaryColorBrightness: Brightness.light,
  canvasColor: kDarkWhite,
  accentColorBrightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  bottomAppBarColor: Color(0xff6D42CE),
  cardColor: Color(0xaaF5E0C3),
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      elevation: 0.0,
      titleTextStyle: TextStyle(
          color: Colors.black, fontSize: 18, fontWeight: FontWeight.w800)),
  dividerColor: Color(0x1f6D42CE),
  focusColor: Color(0x1aF5E0C3),

);

