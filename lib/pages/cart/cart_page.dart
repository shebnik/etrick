import 'package:etrick/constants.dart';
import 'package:etrick/models/cart_model.dart';
import 'package:etrick/models/catalog_model.dart';
import 'package:etrick/pages/home/navigation_pages/catalog/catalog_item_detail.dart';
import 'package:etrick/services/utils.dart';
import 'package:etrick/widgets/item_card.dart';
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
                        return GestureDetector(
                          child: ItemCard(item: item),
                          onTap: () => Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration.zero,
                              pageBuilder: (_, __, ___) => CatalogItemDetail(
                                item: cart.cartToCatalog(item),
                              ),
                            ),
                          ),
                        );
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
}
