import 'package:flutter/material.dart';

class Share with ChangeNotifier {
  bool _count = false;
  bool get count => _count;
  void increment(bools) {
    _count=bools;
    // notifyListeners();
    notifyListeners();
  }
}