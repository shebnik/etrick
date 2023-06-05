import 'dart:convert';
import 'package:flutter/foundation.dart';

class CatalogModel {
  final List<CatalogItem> items;

  CatalogModel({
    required this.items,
  });

  CatalogItem getById(String id) => items.firstWhere(
        (element) => element.id == id,
      );

  CatalogItem getByPosition(int position) {
    return items[position];
  }
}

@immutable
class CatalogItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> colors;

  const CatalogItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.colors,
  });

  CatalogItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    List<String>? colors,
  }) {
    return CatalogItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      colors: colors ?? this.colors,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'colors': colors,
    };
  }

  factory CatalogItem.fromMap(Map<String, dynamic> map) {
    return CatalogItem(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as double,
      colors: List<String>.from((map['colors'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory CatalogItem.fromJson(String source) =>
      CatalogItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CatalogItem(id: $id, name: $name, description: $description, price: $price, colors: $colors)';
  }

  @override
  bool operator ==(covariant CatalogItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        listEquals(other.colors, colors);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        price.hashCode ^
        colors.hashCode;
  }
}
