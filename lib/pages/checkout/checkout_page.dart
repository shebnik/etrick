import 'dart:math';

import 'package:etrick/models/cart_model.dart';
import 'package:etrick/models/purchase.dart';
import 'package:etrick/services/auth_service.dart';
import 'package:etrick/services/firestore_service.dart';
import 'package:etrick/services/utils.dart';
import 'package:etrick/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    var cart = context.watch<CartModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оформлення замовлення'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  var item = cart.items[index];
                  return ItemCard(
                    item: item,
                    canRemove: false,
                  );
                }),
            const SizedBox(height: 16),
            const Divider(),
            Text(
              'Сума до сплати · ${Utils.formatPrice(cart.totalPrice)}',
              textAlign: TextAlign.start,
            ),
            const Divider(),
            ElevatedButton(
              onPressed: () {
                FirestoreService.addPurchase(
                  context.read<AuthService>().user!.uid,
                  Purchase(
                    purchaseId: Random().nextInt(1000000).toString(),
                    products: cart.items,
                    totalPrice: cart.totalPrice,
                  ),
                );
                cart.clear();
                while (context.canPop()) {
                  context.pop();
                }
              },
              child: const Text(
                'ЗАМОВЛЕННЯ ПІДТВЕРДЖУЮ',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
