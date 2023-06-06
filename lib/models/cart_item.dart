class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String? pictureId;
  final String color;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    this.pictureId,
    required this.color,
  });
}