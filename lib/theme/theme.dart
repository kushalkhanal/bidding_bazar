import 'package:flutter/material.dart';

ThemeData biddingBazarTheme() {
  return ThemeData(
    primarySwatch: Colors.red,
    fontFamily: 'Open Sans Regular',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 184, 16, 16),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(
          fontFamily: 'Roboto Regular',
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    ),
  );
}