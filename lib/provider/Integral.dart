import 'package:flutter/material.dart';

class Integral with ChangeNotifier {
  bool _integral = false;
  bool get count => _integral;
  void increment(bools) {
    _integral=bools;
    notifyListeners();
  }
}