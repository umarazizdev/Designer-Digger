import 'package:flutter/material.dart';

class SecurePass extends ChangeNotifier {
  bool _securepass = false;
  bool get securepass => _securepass;
  void setLoading() {
    _securepass = !_securepass;
    notifyListeners();
  }
}
