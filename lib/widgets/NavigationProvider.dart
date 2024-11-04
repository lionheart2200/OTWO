import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  // Current page index
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  // Set the index and notify listeners
  void setPage(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
