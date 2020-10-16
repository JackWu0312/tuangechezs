import 'package:flutter/material.dart';

class Lovecar with ChangeNotifier {
  bool _refreshaddress = false;
  bool get count => _refreshaddress;
  void increment(bools) {
    _refreshaddress=bools;
    notifyListeners();
  }
}
