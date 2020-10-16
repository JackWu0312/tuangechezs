import 'package:flutter/material.dart';

class Backhome with ChangeNotifier {
  int _backhome = 0;
  int get count => _backhome;
  void increment(index) {
    _backhome=index;
    // notifyListeners();
    notifyListeners();
  }
}
