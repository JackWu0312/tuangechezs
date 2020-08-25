import 'package:flutter/material.dart';

class Orderback with ChangeNotifier {
  bool _count = false;
  bool get count => _count;
  void increment(bools) {
    _count=bools;
    // notifyListeners();
    notifyListeners();
  }
}