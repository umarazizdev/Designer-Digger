import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  var _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  void setTheme(thememode) {
    _themeMode = thememode;
    notifyListeners();
  }
}
