import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

class CatalogModel extends ChangeNotifier {
  List<CatalogItem> _items;

  CatalogModel({
    required List<CatalogItem> items,
  }) : _items = items;

  List<CatalogItem> get items => _items;

  set items(List<CatalogItem> items) {
    _items = items;
    notifyListeners();
  }

  List<CatalogItem> getItemsByCategory(String category) => _items
      .where(
        (element) => element.category == category,
      )
      .toList();

  CatalogItem? getById(String id) =>
      _items.firstWhereOrNull((element) => element.id == id);

  CatalogItem getByPosition(int position) {
    return _items[position];
  }
}

@immutable
class CatalogItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<String> colors;

  const CatalogItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.colors,
  });

  CatalogItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    List<String>? colors,
  }) {
    return CatalogItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      colors: colors ?? this.colors,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'colors': colors,
    };
  }

  factory CatalogItem.fromMap(Map<String, dynamic> map) {
    return CatalogItem(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: double.parse(map['price'].toString()),
      category: map['category'],
      colors: List<String>.from(map['colors']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CatalogItem.fromJson(String source) =>
      CatalogItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CatalogItem(id: $id, name: $name, description: $description, price: $price, category: $category, colors: $colors)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CatalogItem &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.category == category &&
        listEquals(other.colors, colors);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        price.hashCode ^
        category.hashCode ^
        colors.hashCode;
  }
}
