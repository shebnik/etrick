import 'package:cached_network_image/cached_network_image.dart';
import 'package:etrick/app_theme.dart';
import 'package:etrick/constants.dart';
import 'package:etrick/models/cart_item.dart';
import 'package:etrick/models/cart_model.dart';
import 'package:etrick/models/catalog_model.dart';
import 'package:etrick/services/storage_service.dart';
import 'package:etrick/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    var cart = context.watch<CartModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кошик'),
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Text(
                'Кошик порожній',
                style: TextStyle(fontSize: 36),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        var item = cart.items[index];
                        return itemCard(item);
                      }),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go(Constants.checkoutLoc),
                    child: Text(
                      'ОФОРМИТИ ЗАМОВЛЕННЯ · ${Utils.formatPrice(cart.totalPrice)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget itemCard(CartItem item) {
    var cart = context.watch<CartModel>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    itemPreview(item),
                    itemQuantity(item),
                  ],
                ),
                Flexible(
                  child: Text(
                    item.name,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 16,
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    cart.remove(item);
                  },
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Text(
                Utils.formatPrice(item.price),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemPreview(CartItem item) => FutureBuilder(
        future: StorageService.getPicture(
          item: CatalogItem.fromCartItem(item),
          pictureId: 0,
          quality: PictureQuality.low,
        ),
        builder: (context, snapshot) => snapshot.hasData
            ? CachedNetworkImage(
                height: 100,
                imageUrl: snapshot.data as String,
                placeholder: (context, url) => const SizedBox.shrink(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
            : const SizedBox.shrink(),
      );

  Widget itemQuantity(CartItem item) {
    var cart = context.watch<CartModel>();
    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          iconSize: 32,
          constraints: const BoxConstraints(),
          splashRadius: 16,
          icon: const Icon(
            Icons.remove,
            color: AppTheme.primaryColor,
          ),
          onPressed: () {
            if (item.quantity > 1) {
              cart.decrement(item);
            }
          },
        ),
        const SizedBox(width: 16),
        Text(
          cart.getItemQuantity(item).toString(),
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(width: 16),
        IconButton(
          padding: EdgeInsets.zero,
          iconSize: 32,
          constraints: const BoxConstraints(),
          splashRadius: 16,
          icon: const Icon(
            Icons.add,
            color: AppTheme.primaryColor,
          ),
          onPressed: () {
            cart.increment(item);
          },
        ),
      ],
    );
  }
}
