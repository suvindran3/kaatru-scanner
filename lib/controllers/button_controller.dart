import 'package:flutter/material.dart';

class ButtonController extends ChangeNotifier {
  bool isLoading = false;

  void updateState() {
    isLoading = !isLoading;
    notifyListeners();
  }
}
