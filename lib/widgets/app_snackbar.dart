import 'package:etrick/app_theme.dart';
import 'package:flutter/material.dart';

class AppSnakbar {
  late final SnackBar snackbar;
  
  AppSnakbar({
    required String text,
  }) {
    snackbar = SnackBar(
      content: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      margin: const EdgeInsets.all(16),
      backgroundColor: AppTheme.primaryColor,
    );
  }
}
