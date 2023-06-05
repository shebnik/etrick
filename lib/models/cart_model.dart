import 'package:etrick/models/catalog_model.dart';
import 'package:flutter/foundation.dart';

class CartModel extends ChangeNotifier {
  late CatalogModel _catalog;

  final List<String> _itemIds = [];

  CatalogModel get catalog => _catalog;

  set catalog(CatalogModel newCatalog) {
    _catalog = newCatalog;
    notifyListeners();
  }

  List<CatalogItem> get items => _itemIds.map((id) => _catalog.getById(id)).toList();

  double get totalPrice =>
      items.fold(0, (total, current) => total + current.price);

  void add(CatalogItem item) {
    _itemIds.add(item.id);
    notifyListeners();
  }

  void remove(CatalogItem item) {
    _itemIds.remove(item.id);
    notifyListeners();
  }
}