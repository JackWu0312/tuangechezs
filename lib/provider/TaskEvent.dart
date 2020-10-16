import 'package:flutter/material.dart';

class TaskEvent with ChangeNotifier {
  bool _count = false;
  bool get count => _count;
  void increment(bools) {
    _count=bools;
    // notifyListeners();
    notifyListeners();
  }
}