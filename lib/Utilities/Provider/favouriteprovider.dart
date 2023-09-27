import 'package:flutter/material.dart';

class FavouriteProvider with ChangeNotifier {
  bool _favourite = false;
  bool get favourite => _favourite;
  setfavourite() {
    _favourite = !_favourite;
    notifyListeners();
  }
}
