import 'package:cached_network_image/cached_network_image.dart';
import 'package:etrick/constants.dart';
import 'package:etrick/models/cart_model.dart';
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
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 16),
                                  FutureBuilder(
                                    future: StorageService.getPicture(
                                      item: item,
                                      pictureId: 0,
                                      quality: PictureQuality.low,
                                    ),
                                    builder: (context, snapshot) => snapshot
                                            .hasData
                                        ? CachedNetworkImage(
                                            height: 100,
                                            imageUrl: snapshot.data as String,
                                            placeholder: (context, url) =>
                                                const SizedBox.shrink(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 32.0),
                                      child: Text(item.name),
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    splashRadius: 16,
                                    icon:
                                        const Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      cart.remove(item);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        splashRadius: 16,
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          if (cart.getItemQuantity(item) > 1) {
                                            cart.decrement(item);
                                          }
                                        },
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        cart.getItemQuantity(item).toString(),
                                      ),
                                      const SizedBox(width: 16),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        splashRadius: 16,
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          cart.increment(item);
                                        },
                                      ),
                                    ],
                                  ),
                                  Text(
                                    Utils.formatPrice(item.price),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
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
}
