import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFF396FE2);
  static const lightBackgroundColor = Color(0xFAFAFAFA);
  static const primaryDark = Color(0xFF474747);

  static get lightTheme => ThemeData.light().copyWith(
        primaryColor: lightBackgroundColor,
        scaffoldBackgroundColor: lightBackgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          elevation: 5,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: primaryColor,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(
              const Size(double.infinity, 48),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(
              const Size(double.infinity, 48),
            ),
          ),
        ),
        textTheme: const TextTheme(
            labelLarge: TextStyle(
          fontSize: 18,
        )),
      );

  static get darkTheme => ThemeData.dark().copyWith(
        primaryColor: primaryDark,
        scaffoldBackgroundColor: primaryDark,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryDark,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: primaryDark,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          hintStyle: TextStyle(
            color: Colors.white54,
          ),
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headline2: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headline3: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headline4: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headline5: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headline6: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyText1: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
          bodyText2: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      );
}
