import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  String activecat = 'All';
  String get _activecat => activecat;
  void setactivecat(String category) {
    activecat = category;
    notifyListeners();
  }
}
