import 'package:flutter/material.dart';

class Item {
  int quantity;

  Item({required this.quantity});
}

class ItemQuantityProvider with ChangeNotifier {
  List<Item> _items = [Item(quantity: 1)];

  List<Item> get items => _items;

  void incrementQuantity(int index) {
    if (index >= 0 && index < _items.length) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(int index) {
    if (index >= 0 && index < _items.length && _items[index].quantity > 1) {
      _items[index].quantity--;
      notifyListeners();
    }
  }
}
