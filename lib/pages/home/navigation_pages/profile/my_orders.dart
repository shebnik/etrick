import 'package:cached_network_image/cached_network_image.dart';
import 'package:etrick/models/app_user.dart';
import 'package:etrick/models/cart_model.dart';
import 'package:etrick/pages/home/home_app_bar.dart';
import 'package:etrick/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<AppUserModel>();
    var cart = context.watch<CartModel>();
    return Scaffold(
      appBar: const HomeAppBar(title: 'Мої замовлення'),
      body: userModel.user!.purchases.isEmpty
          ? const Center(
              child: Text('У вас немає замовлень'),
            )
          : ListView.builder(
              itemCount: userModel.user!.purchases.length,
              itemBuilder: (context, index) {
                var purchase = userModel.user!.purchases[index];
                return purchase.products.isEmpty
                    ? const SizedBox()
                    : Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                'Замовлення №${purchase.purchaseId}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              isThreeLine: true,
                              subtitle: Text(
                                'Вартість: ${purchase.totalPrice} грн\nАдреса: ${purchase.selfDelivery ? "" : 'Нова пошта '}${purchase.address}',
                              ),
                              trailing: Text(
                                purchase.status,
                                style: TextStyle(
                                  color: purchase.status == 'Виконано'
                                      ? Colors.green
                                      : purchase.status == 'Відмінено'
                                          ? Colors.red
                                          : Colors.orange,
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: purchase.products.length,
                              itemBuilder: (context, index) {
                                var product = purchase.products[index];
                                return ListTile(
                                  leading: FutureBuilder(
                                    future: StorageService.getPicture(
                                      item: cart.cartToCatalog(product),
                                      pictureId: 0,
                                      color: product.color,
                                      quality: PictureQuality.low,
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return CachedNetworkImage(
                                          imageUrl: snapshot.data.toString(),
                                          height: 50,
                                          width: 50,
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),
                                  title:
                                      Text('${product.name} ${product.color}'),
                                  subtitle: Text(
                                    '${product.price} ₴ x ${product.quantity} = ${product.price * product.quantity} ₴',
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
              },
            ),
    );
  }
}
