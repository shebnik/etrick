import 'dart:convert';

import 'package:etrick/models/catalog_model.dart';

class CartItem {
  String id;
  String category;
  String name;
  int quantity;
  double price;
  String color;
  List<Pictures>? pictures;

  CartItem({
    required this.id,
    required this.category,
    required this.name,
    required this.quantity,
    required this.price,
    required this.color,
    this.pictures,
  });

  factory CartItem.fromCatalogItem(CatalogItem item) {
    return CartItem(
      id: item.id,
      name: item.name,
      quantity: 1,
      price: item.price,
      color: item.colors.first,
      category: item.category,
      pictures: item.pictures,
    );
  }

  CartItem copyWith({
    String? id,
    String? category,
    String? name,
    int? quantity,
    double? price,
    String? color,
    List<Pictures>? pictures,
  }) {
    return CartItem(
      id: id ?? this.id,
      category: category ?? this.category,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      color: color ?? this.color,
      pictures: pictures ?? this.pictures,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'name': name,
      'quantity': quantity,
      'price': price,
      'color': color,
      'pictures': pictures?.map((x) => x.toMap()).toList(),
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      category: map['category'],
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'].toDouble(),
      color: map['color'],
      pictures:
          map['pictures'] != null ? List<Pictures>.from(map['pictures']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) =>
      CartItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CartItem(id: $id, category: $category, name: $name, quantity: $quantity, price: $price, color: $color)';
  }
}
