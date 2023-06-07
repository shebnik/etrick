import 'package:etrick/models/cart_item.dart';

class Purchase {
  final String purchaseId;
  final List<CartItem> products;
  final double totalPrice;
  final bool selfDelivery;
  final String address;
  final String comment;
  final String status;

  const Purchase({
    required this.purchaseId,
    required this.products,
    required this.totalPrice,
    required this.selfDelivery,
    this.address = '',
    this.comment = '',
    this.status = 'В обробці',
  });

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      purchaseId: map['purchaseId'] as String,
      products: List<CartItem>.from(
          (map['products'] as List).map((e) => CartItem.fromMap(e))),
      totalPrice: map['totalPrice'] as double,
      selfDelivery: map['selfDelivery'] as bool,
      address: map['address'] as String,
      comment: map['comment'] as String,
      status: map['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'purchaseId': purchaseId,
      'products': products.map((e) => e.toMap()).toList(),
      'totalPrice': totalPrice,
      'selfDelivery': selfDelivery,
      'address': address,
      'comment': comment,
      'status': status,
    };
  }

  Purchase copyWith({
    String? purchaseId,
    List<CartItem>? products,
    double? totalPrice,
    bool? selfDelivery,
    String? address,
    String? comment,
    String? status,
  }) {
    return Purchase(
      purchaseId: purchaseId ?? this.purchaseId,
      products: products ?? this.products,
      totalPrice: totalPrice ?? this.totalPrice,
      selfDelivery: selfDelivery ?? this.selfDelivery,
      address: address ?? this.address,
      comment: comment ?? this.comment,
      status: status ?? this.status,
    );
  }
}