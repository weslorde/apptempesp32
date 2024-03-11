import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:flutter/material.dart';

ThemeData myLightThemeData() {
  final AllData _data = AllData();
  return ThemeData(
    
    brightness: Brightness.light,
    //
    //scaffoldBackgroundColor: _data.darkMode ? Colors.white : HexColor.fromHex('#101010'),
    //
    appBarTheme: const AppBarTheme(shadowColor: Colors.transparent),
    //
    //colorScheme: ColorScheme.light(secondary: Colors.green, brightness: Brightness.light),
    //
    /*
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor:  _data.darkMode ? Colors.white : HexColor.fromHex('#101010'),
      unselectedItemColor: _data.darkMode ? Colors.black: Colors.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      elevation: 0.0,
    ),
    */
    //
    //
    

    //End ThemeData
  );
}


ThemeData myDarkThemeData() {
  return ThemeData(
    brightness: Brightness.dark,
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