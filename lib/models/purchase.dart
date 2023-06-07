import 'package:etrick/models/cart_item.dart';

class Purchase {
  final String purchaseId;
  final List<CartItem> products;
  final double totalPrice;
  final String comment;

  const Purchase({
    required this.purchaseId,
    required this.products,
    required this.totalPrice,
    this.comment = '',
  });

  @override
  String toString() {
    return 'Purchase{purchaseId: $purchaseId, products: $products, totalPrice: $totalPrice, comment: $comment}';
  }

  Purchase copyWith({
    String? purchaseId,
    List<CartItem>? products,
    double? totalPrice,
    String? comment,
  }) {
    return Purchase(
      purchaseId: purchaseId ?? this.purchaseId,
      products: products ?? this.products,
      totalPrice: totalPrice ?? this.totalPrice,
      comment: comment ?? this.comment,
    );
  }

  factory Purchase.empty() {
    return const Purchase(
      purchaseId: '',
      products: [],
      totalPrice: 0,
      comment: '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'purchaseId': purchaseId,
      'products': products.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'comment': comment,
    };
  }

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      purchaseId: map['purchaseId'],
      products: List<CartItem>.from(
          map['products']?.map((x) => CartItem.fromMap(x))),
      totalPrice: map['totalPrice'],
      comment: map['comment'],
    );
  }
}