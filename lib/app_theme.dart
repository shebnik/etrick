import 'package:flutter/material.dart';

class NoTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class AppTheme {
  static const primaryColor = Color(0xff5aa77f);
  static const lightBackgroundColor = Color(0xFAFAFAFA);
  static const primaryDark = Color(0xFF474747);

  static get lightTheme => ThemeData.light().copyWith(
        primaryColor: primaryColor,
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.all(primaryColor),
        ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: NoTransitionsBuilder(),
            TargetPlatform.iOS: NoTransitionsBuilder(),
          },
        ),
        scaffoldBackgroundColor: lightBackgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          elevation: 5,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.primaryColor,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          labelStyle: TextStyle(
            color: Colors.black,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: primaryColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black54,
          selectedIconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryColor),
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
            color: Colors.black,
          ),
          labelMedium: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          labelSmall: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          headlineLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headlineMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headlineSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          bodySmall: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );

  static get darkTheme => lightTheme;
}
