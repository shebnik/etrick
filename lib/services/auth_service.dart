import 'dart:async';

import 'package:etrick/models/app_user.dart';
import 'package:etrick/services/firestore_service.dart';
import 'package:etrick/services/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get user => _auth.currentUser;

  bool get isSignedIn => _auth.currentUser != null;

  void initialize() {
    authStateChanges.listen((User? user) {
      if (user == null) {
        Utils.log('User is currently signed out!');
      } else {
        Utils.log('User is signed in!');
      }
    });
  }

  bool isEmailValid(String email) {
    return RegExp(r'^.+@.+\..+$').hasMatch(email);
  }

  bool isPasswordValid(String password) {
    return RegExp(r'^.{8,}$').hasMatch(password);
  }

  bool isFirstNameValid(String firstName) {
    return RegExp(r'^.{2,}$').hasMatch(firstName);
  }

  bool isLastNameValid(String lastName) {
    return RegExp(r'^.{2,}$').hasMatch(lastName);
  }

  Future<Map<bool, String>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Utils.log(
          '[signInWithEmailAndPassword] User: ${_auth.currentUser!.email} is logged in!');
      return {
        true: "success",
      };
    } on FirebaseAuthException catch (e) {
      Utils.log('[signInWithEmailAndPassword] FirebaseAuthException: $e');
      return {
        false: e.toString(),
      };
    } catch (e) {
      Utils.log('[signInWithEmailAndPassword] error$e');
      return {
        false: e.toString(),
      };
    }
  }

  String getFirebaseAuthErrorMessage(String errorString) {
    String errorCode;
    try {
      errorCode = errorString
          .substring(errorString.indexOf("(") + 1, errorString.indexOf(")"))
          .replaceAll("auth/", "");
    } catch (e) {
      errorCode = errorString
          .substring(errorString.indexOf("[") + 1, errorString.indexOf("]"))
          .replaceAll("firebase_auth/", "");
    }
    switch (errorCode) {
      case 'invalid-email':
      case 'user-not-found':
        return 'Користувача з таким email не знайдено';
      case 'wrong-password':
        return 'Невірний пароль';
      case 'user-disabled':
        return 'Користувача заблоковано';
      case 'too-many-requests':
        return 'Забагато спроб. Спробуйте пізніше';
      case 'operation-not-allowed':
        return 'Операція не дозволена';
      case 'email-already-in-use':
        return 'Користувач з таким email вже існує';
      case 'weak-password':
        return 'Пароль занадто простий';
      default:
        return errorString.substring(errorString.indexOf("] ") + 2);
    }
  }

  Future<void> signOut() async {
    Utils.log('Signing out');
    await _auth.signOut();
  }

  Future<Map<bool, String>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Utils.log('[resetPassword] Email sent');
      return {
        true: "success",
      };
    } on FirebaseAuthException catch (e) {
      Utils.log('[resetPassword] FirebaseAuthException: $e');
      return {
        false: e.toString(),
      };
    } catch (e) {
      Utils.log('[resetPassword] error$e');
      return {
        false: e.toString(),
      };
    }
  }

  Future<Map<bool, String>> createAccount(
      AppUser appUser, String password) async {
    try {
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: appUser.email,
        password: password,
      );
      Utils.log('[createAccount] User: ${_auth.currentUser!.email} is created!');
      await _auth.currentUser!
          .updateDisplayName('${appUser.firstName} ${appUser.lastName}');
      await FirestoreService.createUser(appUser.copyWith(
        id: user.user!.uid,
        email: user.user!.email,
      ));
      return {
        true: "success",
      };
    } on FirebaseAuthException catch (e) {
      Utils.log('[createAccount] FirebaseAuthException: $e');
      return {
        false: e.toString(),
      };
    } catch (e) {
      Utils.log('[createAccount] error$e');
      return {
        false: e.toString(),
      };
    }
  }

  // login
  Future<Map<bool, String>> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Utils.log('[login] User: ${_auth.currentUser!.email} is logged in!');
      return {
        true: "success",
      };
    } on FirebaseAuthException catch (e) {
      Utils.log('[login] FirebaseAuthException: $e');
      return {
        false: e.toString(),
      };
    } catch (e) {
      Utils.log('[login] error$e');
      return {
        false: e.toString(),
      };
    }
  }
}
