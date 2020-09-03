import 'package:flutter/material.dart';

class Addressselect with ChangeNotifier {
  Map _addressselect = {};
  // bool isSelect=false;
  Map get count => _addressselect;
  void increment(addressselect) {
    _addressselect=addressselect;
    notifyListeners();
  }
}
