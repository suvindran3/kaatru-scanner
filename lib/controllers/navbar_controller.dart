import 'package:flutter/material.dart';

class NavbarController extends ChangeNotifier {
  int currentIndex = 0;

  void updateIndex(int index, {PageController? pageController}) {
    if (index != currentIndex) {
      currentIndex = index;
      if (pageController != null) {
        pageController.animateToPage(index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.decelerate);
      }
      notifyListeners();
    }
  }
}
