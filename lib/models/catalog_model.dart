import 'dart:convert';
import 'package:etrick/providers/shared_preferences_provider.dart';
import 'package:etrick/services/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void notifyListeners() {
    super.notifyListeners();
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

  Future<void> saveCatalogItem(
      CatalogItem item, List<Pictures> pictures) async {
    item = item.copyWith(pictures: pictures);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    item = item.copyWith(pictures: pictures);
    await prefs.setString(
      item.id,
      item.toJson(),
    );
    Utils.log("[CatalogModel] saveCatalog: ${item.pictures}");
  }

  CatalogItem? getCatalogItem(BuildContext context, CatalogItem item) {
    SharedPreferences prefs =
        context.read<SharedPreferencesProvider>().instance;
    String? encodedItem = prefs.getString(item.id);
    if (encodedItem != null) {
      item = CatalogItem.fromJson(encodedItem);
      Utils.log("[CatalogModel] getCatalog: ${item.pictures}");
      items.firstWhere((element) => element.id == item.id).copyWith(
            pictures: item.pictures,
          );
      return item;
    }
    return null;
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
  final List<Pictures>? pictures;

  const CatalogItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.colors,
    this.pictures,
  });

  CatalogItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    List<String>? colors,
    List<Pictures>? pictures,
  }) {
    return CatalogItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      colors: colors ?? this.colors,
      pictures: pictures ?? this.pictures,
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
      'pictures': pictures?.map((x) => x.toMap()).toList(),
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
      pictures: map['pictures'] != null
          ? List<Pictures>.from(map['pictures'].map((x) => Pictures.fromMap(x)))
          : null,
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

class Pictures {
  final String color;
  final List<String> urls;

  const Pictures({
    required this.color,
    required this.urls,
  });

  Pictures copyWith({
    String? color,
    List<String>? urls,
  }) {
    return Pictures(
      color: color ?? this.color,
      urls: urls ?? this.urls,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'color': color,
      'urls': urls,
    };
  }

  factory Pictures.fromMap(Map<String, dynamic> map) {
    return Pictures(
      color: map['color'],
      urls: List<String>.from(map['urls']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Pictures.fromJson(String source) =>
      Pictures.fromMap(json.decode(source));

  @override
  String toString() => 'Pictures(color: $color, urls: $urls)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pictures &&
        other.color == color &&
        listEquals(other.urls, urls);
  }

  @override
  int get hashCode => color.hashCode ^ urls.hashCode;
}
