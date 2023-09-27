import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  bool _cartitem = false;
  bool get cartitem => _cartitem;
  setfavourite() {
    _cartitem = !_cartitem;
    notifyListeners();
  }
}
