import 'package:flutter/material.dart';

class ErrorDialog {
  static bool _isOpen = false;

  static Future<dynamic> show(BuildContext context, String errorMessage,
      {VoidCallback? action, bool barrier = true, String? buttonText}) async {
    if (_isOpen) {
      return null;
    } else {
      _isOpen = true;
      return showGeneralDialog(
        context: context,
        barrierDismissible: barrier,
        barrierLabel: '',
        transitionBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation, Widget child) =>
            Transform.scale(
          scale: animation.value,
          child: child,
        ),
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          actionsPadding: const EdgeInsets.only(bottom: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          title: const Icon(
            Icons.error_outlined,
            color: Colors.brown,
            size: 100,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Error',
                style: Theme.of(context).textTheme.headline1?.copyWith(
                    color: Colors.brown,
                    fontWeight: FontWeight.bold,
                    fontSize: 19),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (action != null) {
                  action();
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.brown),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: Text(buttonText ?? 'Try again'),
            ),
          ],
        ),
      ).whenComplete(() => _isOpen = false);
    }
  }
}
