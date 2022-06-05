import 'package:flutter/material.dart';

ColorScheme colorScheme = const ColorScheme.light(primary: Color.fromARGB(255, 47, 111, 78));

ThemeData myTheme = ThemeData(
  colorScheme: const ColorScheme.light(primary: Color.fromARGB(255, 47, 111, 78)),
  platform: TargetPlatform.iOS,
  textTheme: const TextTheme(
    headline1: TextStyle(fontSize: 30.0,color: Colors.black,fontWeight: FontWeight.bold),
    headline2: TextStyle(fontSize: 26.0,color: Colors.black,fontWeight: FontWeight.bold),
    headline3: TextStyle(fontSize: 24.0,color: Colors.black,fontWeight: FontWeight.bold),
    headline4: TextStyle(fontSize: 22.0,color: Colors.black),
    headline5: TextStyle(fontSize: 20.0,color: Colors.black),
    headline6: TextStyle(fontSize: 18.0,color: Colors.black),
    bodyText1: TextStyle(fontSize: 15.0,color: Color.fromARGB(255, 17, 17, 17)),
    bodyText2: TextStyle(fontSize: 15.0,color: Color.fromARGB(255, 27, 27, 27)),
    caption: TextStyle(fontSize: 13.0,color:Color.fromARGB(255, 37, 37, 37)),
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0,
    titleTextStyle: TextStyle(fontSize: 24.0)
  ),
  // errorColor: const Color.fromARGB(255, 114, 16, 9),
  errorColor: Colors.red,
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
);