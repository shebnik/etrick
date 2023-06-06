import 'package:etrick/models/catalog_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartModel extends ChangeNotifier {
  late CatalogModel _catalog;
  final Map<String, int> _items = {};

  CatalogModel get catalog => _catalog;

  set catalog(CatalogModel newCatalog) {
    _catalog = newCatalog;
    notifyListeners();
  }

  List<CatalogItem> get items => _items.keys
      .map((id) => _catalog.getById(id))
      .where((item) => item != null)
      .toList()
      .cast<CatalogItem>();

  int getItemsCount() => items.fold(
        0,
        (total, item) => total + _items[item!.id]!,
      );

  double get totalPrice => items.fold(
        0,
        (total, item) => total + (item!.price * _items[item.id]!),
      );

  Future<void> loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedCartList = prefs.getStringList('cart');

    if (savedCartList != null) {
      Map<String, int> savedQuantities = savedCartList.fold(
        {},
        (Map<String, int> quantities, String item) {
          List<String> parts = item.split(':');
          quantities[parts[0]] = int.parse(parts[1]);
          return quantities;
        },
      );

      _items.clear();
      _items.addAll(savedQuantities);
      notifyListeners();
    }
  }

  Future<void> saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartList = _items.entries
        .map((entry) => '${entry.key}:${entry.value.toString()}')
        .toList();
    await prefs.setStringList('cart', cartList);
  }

  void add(CatalogItem item) {
    if (_items.containsKey(item.id)) {
      _items[item.id] = _items[item.id]! + 1;
    } else {
      _items[item.id] = 1;
    }
    notifyListeners();
  }

  void remove(CatalogItem item) {
    _items.remove(item.id);
    notifyListeners();
  }

  void decrement(CatalogItem item) {
    if (_items.containsKey(item.id)) {
      if (_items[item.id]! > 1) {
        _items[item.id] = _items[item.id]! - 1;
      } else {
        remove(item);
      }
      notifyListeners();
    }
  }

  void increment(CatalogItem item) {
    if (_items.containsKey(item.id)) {
      _items[item.id] = _items[item.id]! + 1;
    }
    notifyListeners();
  }

  int getItemQuantity(CatalogItem item) {
    return _items[item.id] ?? 0;
  }

  bool isInCart(CatalogItem item) {
    return items.any((cartItem) => item == cartItem);
  }

  @override
  void notifyListeners() {
    saveCart();
    super.notifyListeners();
  }
}
