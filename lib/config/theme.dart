import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ColorScheme colorScheme = const ColorScheme.light(primary: Color.fromARGB(255, 47, 111, 78));

ThemeData myTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(primary: Color.fromARGB(255, 47, 111, 78)),
  platform: TargetPlatform.iOS,
  textTheme: const TextTheme(
    headline1: TextStyle(fontSize: 30.0,color: CupertinoColors.black,fontWeight: FontWeight.bold),
    headline2: TextStyle(fontSize: 26.0,color: CupertinoColors.black,fontWeight: FontWeight.bold),
    headline3: TextStyle(fontSize: 24.0,color: CupertinoColors.black,fontWeight: FontWeight.bold),
    headline4: TextStyle(fontSize: 22.0,color: CupertinoColors.black,fontWeight: FontWeight.normal),
    headline5: TextStyle(fontSize: 20.0,color: CupertinoColors.black,fontWeight: FontWeight.normal),
    headline6: TextStyle(fontSize: 18.0,color: CupertinoColors.black,fontWeight: FontWeight.normal),
    bodyText1: TextStyle(fontSize: 15.0,color: CupertinoColors.secondaryLabel),
    bodyText2: TextStyle(fontSize: 15.0,color: CupertinoColors.systemGrey),
    caption: TextStyle(fontSize: 13.0,color:CupertinoColors.systemGrey2),
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0,
    titleTextStyle: TextStyle(fontSize: 24.0)
  ),
  // errorColor: const Color.fromARGB(255, 114, 16, 9),
  errorColor: CupertinoColors.systemRed,
  primaryColor: const Color.fromARGB(255, 47, 111, 78),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color.fromARGB(255, 47, 111, 78)
  ),
  backgroundColor: Colors.white,
  scaffoldBackgroundColor: const Color.fromARGB(255, 237, 241, 247),
  cardColor: Colors.white,
  dialogTheme: const DialogTheme(
    alignment: Alignment.center,
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 17, 17, 17)),
    contentTextStyle: TextStyle(fontSize: 15,color: Color.fromARGB(255, 27, 27, 27))
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.windows: CupertinoPageTransitionsBuilder()
    }
  ),
  cupertinoOverrideTheme: const CupertinoThemeData.raw(Brightness.light, null, null, null, null, null)
);

ThemeData myDarkTheme = ThemeData(
  brightness: Brightness.light,
  //colorScheme: const ColorScheme.light(primary: Color.fromARGB(255, 47, 111, 78)),
  platform: TargetPlatform.iOS,
  textTheme: const TextTheme(
    headline1: TextStyle(fontSize: 30.0,color: CupertinoColors.white,fontWeight: FontWeight.bold),
    headline2: TextStyle(fontSize: 26.0,color: CupertinoColors.white,fontWeight: FontWeight.bold),
    headline3: TextStyle(fontSize: 24.0,color: CupertinoColors.white,fontWeight: FontWeight.bold),
    headline4: TextStyle(fontSize: 22.0,color: CupertinoColors.white,fontWeight: FontWeight.normal),
    headline5: TextStyle(fontSize: 20.0,color: CupertinoColors.white,fontWeight: FontWeight.normal),
    headline6: TextStyle(fontSize: 18.0,color: CupertinoColors.white,fontWeight: FontWeight.normal),
    bodyText1: TextStyle(fontSize: 15.0,color: CupertinoColors.systemGrey4),
    bodyText2: TextStyle(fontSize: 15.0,color: CupertinoColors.systemGrey2),
    caption: TextStyle(fontSize: 13.0,color:CupertinoColors.systemGrey),
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0,
    titleTextStyle: TextStyle(fontSize: 24.0)
  ),
  // errorColor: const Color.fromARGB(255, 114, 16, 9),
  errorColor: CupertinoColors.systemRed,
  primaryColor: const Color.fromARGB(255, 14, 14, 14),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color.fromARGB(255, 47, 111, 78)
  ),
  backgroundColor: const Color.fromARGB(255, 14, 14, 14),
  scaffoldBackgroundColor: const Color.fromARGB(255, 24, 24, 24),
  cardColor: const Color.fromARGB(255, 14, 14, 14),
  dialogTheme: const DialogTheme(
    alignment: Alignment.center,
    backgroundColor: Color.fromARGB(255, 14, 14, 14),
    titleTextStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: CupertinoColors.white),
    contentTextStyle: TextStyle(fontSize: 15,color: CupertinoColors.systemGrey4)
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.windows: CupertinoPageTransitionsBuilder()
    }
  ),
  cupertinoOverrideTheme: const CupertinoThemeData.raw(Brightness.dark, null, null, null, null, null)
);