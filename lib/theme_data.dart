import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:flutter/material.dart';

ThemeData myThemeData() {
  return ThemeData(
    primaryColor: Colors.blue,
    //
    //
    scaffoldBackgroundColor: Colors.white,
    //
    //
    appBarTheme: const AppBarTheme(shadowColor: Colors.transparent),
    //
    //
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      unselectedItemColor: Colors.black,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      elevation: 0.0,
    ),
    //
    //
    

    //End ThemeData
  );
}
