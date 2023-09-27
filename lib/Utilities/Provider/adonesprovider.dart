import 'package:flutter/material.dart';

class AdOnesProvider extends ChangeNotifier {
  String activecatt = '';
  String get _activecatt => activecatt;
  void setactivecat(String category) {
    activecatt = category;
    notifyListeners();
  }
}
