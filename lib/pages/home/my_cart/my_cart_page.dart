import 'package:etrick/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCartPage extends StatefulWidget {
  const MyCartPage({super.key});

  @override
  State<MyCartPage> createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: const Text('Корзіна'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _CartList(),
          ),
          const Divider(height: 4, color: Colors.black),
          SizedBox(
            height: 200,
            child: Center(
              child: Consumer<CartModel>(
                builder: (context, cart, child) => Text(
                  'С вас: ${cart.totalPrice} грн',
                  style: const TextStyle(fontSize: 50),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cart = context.watch<CartModel>();

    return ListView.builder(
      itemCount: cart.items.length,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(
          Icons.done,
          color: Colors.green,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {
            cart.remove(cart.items[index]);
          },
        ),
        title: Text(
          '${cart.items[index].name} - ${cart.items[index].price} грн.',
        ),
      ),
    );
  }
}