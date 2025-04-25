// navigation_provider.dart
import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  String? _pageData; // Stores data for the target page

  int get currentIndex => _currentIndex;
  String? get pageData => _pageData;

  void navigateTo(int index, {String? data}) {
    _currentIndex = index;
    _pageData = data; // Store the passed data
    notifyListeners();
  }
}
