import 'package:cached_network_image/cached_network_image.dart';
import 'package:etrick/app_theme.dart';
import 'package:etrick/models/cart_item.dart';
import 'package:etrick/models/cart_model.dart';
import 'package:etrick/services/storage_service.dart';
import 'package:etrick/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({
    Key? key,
    required this.item,
    this.canRemove = true,
  }) : super(key: key);

  final CartItem item;
  final bool canRemove;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
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
                    itemPreview(widget.item),
                    const SizedBox(height: 8),
                    itemQuantity(widget.item),
                  ],
                ),
                Flexible(
                  child: Text(
                    widget.item.name,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.canRemove)
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 16,
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      cart.remove(widget.item);
                    },
                  ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Text(
                Utils.formatPrice(widget.item.price * widget.item.quantity),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemPreview(CartItem item) {
    var cart = context.watch<CartModel>();
    return FutureBuilder(
        future: StorageService.getPicture(
          item: cart.cartToCatalog(item),
          pictureId: 0,
          quality: PictureQuality.low,
          color: item.color,
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
  }

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
        SizedBox(
          width: 30,
          child: Text(
            cart.getItemQuantity(item).toString(),
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
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
