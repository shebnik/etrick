import 'dart:convert';

import 'package:etrick/models/cart_item.dart';
import 'package:etrick/models/catalog_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartModel extends ChangeNotifier {
  late CatalogModel _catalog;
  final List<CartItem> _items = [];

  CatalogModel get catalog => _catalog;

  set catalog(CatalogModel newCatalog) {
    _catalog = newCatalog;
    notifyListeners();
  }

  List<CartItem> get items => _items;

  int getItemsCount() => items.fold(0, (total, item) => total + item.quantity);

  double get totalPrice => items.fold(
        0,
        (total, item) => total + (item.price * item.quantity),
      );

  CatalogItem cartToCatalog(CartItem item) {
    return _catalog.items
        .firstWhere((catalogItem) => catalogItem.id == item.id);
  }

  Future<void> loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedCart = prefs.getStringList('cart');

    if (savedCart != null) {
      final savedItems =
          savedCart.map((item) => CartItem.fromJson(jsonDecode(item))).toList();
      _items.clear();
      _items.addAll(savedItems);
      notifyListeners();
    }
  }

  Future<void> saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'cart',
      items.map((item) => jsonEncode(item.toJson())).toList(),
    );
  }

  void add(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void decrement(CartItem item) {
    final index = _items.indexOf(item);
    if (index >= 0) {
      final currentItem = _items[index];
      if (currentItem.quantity > 1) {
        currentItem.quantity -= 1;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void increment(CartItem item) {
    final index = _items.indexOf(item);
    if (index >= 0) {
      final currentItem = _items[index];
      currentItem.quantity += 1;
      notifyListeners();
    }
  }

  int? getItemQuantity(CartItem item) {
    final index = _items.indexOf(item);
    if (index >= 0) {
      return _items[index].quantity;
    }
    return null;
  }

  bool isInCart(CartItem item, bool colorCheck) {
    return items.any(
      (cartItem) =>
          item.id == cartItem.id &&
          (colorCheck ? item.color == cartItem.color : true),
    );
  }

  @override
  void notifyListeners() {
    saveCart();
    super.notifyListeners();
  }
}
