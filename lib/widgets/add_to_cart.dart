import 'package:etrick/app_theme.dart';
import 'package:etrick/constants.dart';
import 'package:etrick/models/cart_item.dart';
import 'package:etrick/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddToCart extends StatelessWidget {
  final CartItem item;
  final bool colorCheck;

  const AddToCart({
    required this.item,
    Key? key,
    required this.colorCheck,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<CartModel>();
    var isInCart = cart.isInCart(item, colorCheck);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isInCart ? AppTheme.primaryColor : Colors.grey,
          width: 2,
        ),
      ),
      child: IconButton(
        iconSize: 32,
        icon: Icon(
          isInCart ? Icons.shopping_cart : Icons.shopping_cart_outlined,
          color: isInCart ? AppTheme.primaryColor : Colors.grey,
        ),
        onPressed: isInCart
            ? () => context.push(Constants.cartLoc)
            : () {
                context.read<CartModel>().add(item);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Товар додан у кошик',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    margin: EdgeInsets.all(16),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
      ),
    );
  }
}
