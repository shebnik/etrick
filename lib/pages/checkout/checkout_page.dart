import 'package:etrick/constants.dart';
import 'package:etrick/models/cart_model.dart';
import 'package:etrick/services/utils.dart';
import 'package:etrick/widgets/item_card.dart';
import 'package:flutter/material.dart';
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
        title: const Text('Кошик'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
            Divider(),
            Text('Сума до сплати · ${Utils.formatPrice(cart.totalPrice)}'),
            Divider(),
            ElevatedButton(
              onPressed: () => {
                // TODO: Add order to database
              },
              child: Text(
                'ЗАМОВЛЕННЯ ПІДТВЕРДЖУЮ',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
