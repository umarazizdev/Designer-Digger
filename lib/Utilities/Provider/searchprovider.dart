import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  String _text = "English (UK)";

  String get text => _text;

  void updateText(String newText) {
    _text = newText;
    notifyListeners();
  }

  String _searchprovider = '';
  String get searchprovider => _searchprovider;
  setserach(String value) {
    _searchprovider = value;
    notifyListeners();
  }
}
