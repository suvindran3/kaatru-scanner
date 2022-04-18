import 'dart:async';
import 'dart:io';
import 'package:device_scanner/models/user_model.dart';
import 'package:device_scanner/test.dart';
import 'package:flutter/material.dart';
import '../components/custom_snack_bar.dart';
import 'package:intl/intl.dart';
import '../components/error_dialog.dart';
import '../main.dart';
import '../network/database.dart';
import '../screens/home_screen.dart';
import '../screens/sign_in_screen.dart';

class Operations {
  static int _count = 0;

  static Future<bool> exit(BuildContext context) async {
    _count++;
    Future.delayed(const Duration(seconds: 2), () => _count = 0);
    if (_count > 1) {
      return true;
    } else {
      CustomSnackBar.show(
        ratio: 3.5,
        context: context,
        content: 'Press again to exit',
      );
      return false;
    }
  }

  static Future<bool> connectionCheck() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  static Future<void> handleNetworkError(
      {required BuildContext context,
      required String errorMessage,
      required VoidCallback callToAction,
      String? buttonText}) async {
    final bool internetCheck = await Operations.connectionCheck();
    if (internetCheck) {
      await ErrorDialog.show(context, errorMessage,
          action: callToAction, buttonText: buttonText);
    } else {
      await ErrorDialog.show(
        context,
        'Please check your internet connection and try again',
        action: callToAction,
      );
    }
  }

  static Future<void> navigate() async {
    if (Database.user.id.isNotEmpty) {
      await Navigator.pushReplacement(
        kNavigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      await Navigator.pushReplacement(
        kNavigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
      );
    }
  }

  static Future<void> signIn(
      {required BuildContext context,
      required String userID,
      required String password,
      required VoidCallback onError}) async {
    final Map<String, dynamic> user =
        await secureTry(Database.getUser(userID: userID)) ?? {};
    if (user.isEmpty) {
      onError();
      ErrorDialog.show(context, 'Invalid user id');
    } else if (user[param.password.name] != password) {
      onError();
      ErrorDialog.show(context, 'Wrong password. Please try again');
    } else if (user[param.password.name] == password) {
      Database.user = UserModel.fromJson(user);
      await secureTry(Database.saveUser());
      await secureTry(Database.addFcmToken());
      navigate();
    }
  }

  static String getTimestamp() => DateFormat('hh:mm a, dd MMMM yyyy').format(
        DateTime.now().toLocal(),
      );
}
