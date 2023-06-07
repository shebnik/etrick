import 'package:etrick/models/app_user.dart';
import 'package:etrick/models/catalog_model.dart';
import 'package:etrick/services/auth_service.dart';
import 'package:etrick/services/firestore_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Utils {
  static String formatPrice(double value) =>
      "${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2).replaceAll(RegExp(r'\.00$'), '').replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match.group(1)} ')} ₴";

  static Color getColorFromText(String colorText) {
    colorText = colorText.toLowerCase();

    if (colorText.contains('red')) {
      return Colors.red;
    } else if (colorText.contains('green')) {
      return Colors.green;
    } else if (colorText.contains('blue')) {
      return Colors.blue;
    } else if (colorText.contains('yellow')) {
      return Colors.yellow;
    } else if (colorText.contains('orange')) {
      return Colors.orange;
    } else if (colorText.contains('purple')) {
      return Colors.purple;
    } else if (colorText.contains('pink')) {
      return Colors.pink;
    } else if (colorText.contains('brown')) {
      return Colors.brown;
    } else if (colorText.contains('grey') || colorText.contains('gray')) {
      return Colors.grey;
    } else if (colorText.contains('white')) {
      return Colors.white;
    } else if (colorText.contains('black')) {
      return Colors.black;
    } else {
      return Colors.transparent;
    }
  }

  static showPageNoAnimation(BuildContext context, Widget page) {
    return Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => page,
      ),
    );
  }

  static String capitalize(String color) {
    // capitalize all words in string
    return color.split(' ').map((word) {
      String firstLetter = word.substring(0, 1).toUpperCase();
      String rest = word.substring(1);
      return '$firstLetter$rest';
    }).join(' ');
  }

  // ignore: avoid_print
  static log(String message) => kDebugMode ? print(message) : null;

  static bool validateAddress(String text) {
    if (text.length < 5) {
      return false;
    }
    return true;
  }

  static bool validatePhoneNumber(String text) {
    if (text.length == 9) {
      return true;
    }
    return false;
  }

  static void fetchData(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final appUserModel = context.read<AppUserModel>();
      final auth = context.read<AuthService>();
      final catalog = context.read<CatalogModel>();
      appUserModel.user = await FirestoreService.getUserById(auth.user!.uid);
      catalog.items = await FirestoreService.getCatalog();
    });
  }
}
