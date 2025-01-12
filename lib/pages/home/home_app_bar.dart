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
      title: context.canPop()
          ? Text(title)
          : Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 8),
                Text(title),
              ],
            ),
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
                    color: Colors.white,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    cartItemsCount.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
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
