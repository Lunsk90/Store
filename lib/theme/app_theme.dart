// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Colors.indigoAccent;

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.indigo,
    appBarTheme: const AppBarTheme(
      color: primary,
      elevation: 0,
    ),
    //TexButton Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: primary),
    ),
    //FloatingActionButtonTheme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary, elevation: 4),
    //ElevationButonTheme
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            primary: primary, shape: const StadiumBorder(), elevation: 0)),
    //Input
    inputDecorationTheme: const InputDecorationTheme(
        floatingLabelStyle: TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10))),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10)))),
  );

  //Dark
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.indigo,
    appBarTheme: const AppBarTheme(
      color: primary,
      elevation: 0,
    ),
  );
}
