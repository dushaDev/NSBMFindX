// navigation_provider.dart
import 'package:flutter/material.dart';

// This is a simple navigation provider class that uses ChangeNotifier
// to manage the current index of a bottom navigation bar.
// It allows the UI to listen for changes and rebuild accordingly.

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners(); // Notify UI to rebuild
  }
}
