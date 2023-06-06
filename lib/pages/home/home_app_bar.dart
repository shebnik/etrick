import 'package:etrick/constants.dart';
import 'package:etrick/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    Key? key,
    this.title = 'eTrick',
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<CartModel>();
    int cartItemsCount = cart.getItemsCount();
    return AppBar(
      title: Text(title),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                context.push(Constants.cartLoc);
              },
            ),
            if (cartItemsCount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    cartItemsCount.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
