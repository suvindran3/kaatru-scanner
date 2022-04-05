import 'package:flutter/material.dart';

class CustomSnackBar {
  static Future<void> show({
    required BuildContext context,
    required String content,
    required double ratio,
  }) async {
    final double width = MediaQuery.of(context).size.width;
    final SnackBar snackBar = SnackBar(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: width/ratio, vertical: 30),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.grey.shade200,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .bodyText2
            ?.copyWith(color: Colors.black87, fontWeight: FontWeight.bold),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
