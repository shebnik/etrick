import 'package:flutter/foundation.dart';

class SearchProvider extends ChangeNotifier {
  String _searchText = '';

  String get searchValue => _searchText;

  set searchValue(String value) {
    _searchText = value;
    notifyListeners();
  }

  void clearSearch() {
    _searchText = '';
    notifyListeners();
  }
}
