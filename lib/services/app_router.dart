import 'package:etrick/constants.dart';
import 'package:etrick/pages/auth/create_account_page.dart';
import 'package:etrick/pages/auth/login_page.dart';
import 'package:etrick/pages/auth/reset_password.dart';
import 'package:etrick/pages/checkout/checkout_page.dart';
import 'package:etrick/pages/home/home_page.dart';
import 'package:etrick/pages/cart/cart_page.dart';
import 'package:etrick/pages/home/navigation_pages/catalog/category_page.dart';
import 'package:etrick/services/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final ValueListenable<User?> firebaseUser;

  AppRouter(this.firebaseUser);

  late final router = GoRouter(
    refreshListenable: firebaseUser,
    redirect: (context, state) async {
      final bool loggingIn =
          state.matchedLocation == Constants.createAccountLoc ||
              state.matchedLocation == Constants.loginLoc ||
              state.matchedLocation == Constants.resetPasswordLoc;
      final bool loggedIn = firebaseUser.value != null;

      if (!loggedIn && !loggingIn) {
        Utils.log('redirecting to login page');
        return Constants.createAccountLoc;
      }
      if (loggedIn &&
          [
            Constants.createAccountLoc,
            Constants.loginLoc,
            Constants.resetPasswordLoc
          ].contains(state.matchedLocation) &&
          state.queryParameters.isEmpty) {
        Utils.log('redirecting to root page');
        return Constants.homeLoc;
      }
      return null;
    },
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: Constants.createAccountLoc,
        builder: (context, routerState) => const CreateAccountPage(),
      ),
      GoRoute(
        path: Constants.loginLoc,
        builder: (context, routerState) => const LoginPage(),
      ),
      GoRoute(
        path: Constants.resetPasswordLoc,
        builder: (context, routerState) => const ResetPassword(),
      ),
      GoRoute(
        path: Constants.homeLoc,
        builder: (context, routerState) => const HomePage(),
      ),
      GoRoute(
        path: Constants.cartLoc,
        builder: (context, routerState) => const CartPage(),
      ),
      ...Constants.categories.keys.map((String category) {
        return GoRoute(
          path: '/$category',
          builder: (context, routerState) => CategoryPage(
            category: category,
          ),
        );
      }).toList(),
      GoRoute(
        path: Constants.checkoutLoc,
        builder: (context, routerState) => const CheckoutPage(),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      child: Text(state.error.toString()),
    ),
  );
}