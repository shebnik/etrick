import 'package:cached_network_image/cached_network_image.dart';
import 'package:etrick/models/app_user.dart';
import 'package:etrick/models/cart_model.dart';
import 'package:etrick/models/purchase.dart';
import 'package:etrick/pages/home/home_app_bar.dart';
import 'package:etrick/services/storage_service.dart';
import 'package:etrick/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      var userModel = context.read<AppUserModel>();
      await userModel.loadUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<AppUserModel>();
    userModel.user!.purchases.sort((a, b) => b.date.compareTo(a.date));
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
                String title = 'Замовлення №${purchase.purchaseId}';
                String subtitle =
                    'Дата: ${Utils.formatDate(purchase.date)}\nВартість: ${Utils.formatPrice(purchase.totalPrice)} грн\nАдреса: ${purchase.selfDelivery ? "" : 'Нова пошта '}${purchase.address}';
                return purchase.products.isEmpty
                    ? const SizedBox()
                    : Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              isThreeLine: true,
                              subtitle: Text(
                                subtitle,
                              ),
                              trailing: Text(
                                purchase.status,
                                style: TextStyle(
                                  color: purchase.status == 'Виконано'
                                      ? Colors.green
                                      : purchase.status == 'Скасовано' || purchase.status == 'Відмінено'
                                          ? Colors.red
                                          : Colors.orange,
                                ),
                              ),
                            ),
                            purchaseProductsList(purchase),
                          ],
                        ),
                      );
              },
            ),
    );
  }

  Widget purchaseProductsList(Purchase purchase) {
    var cart = context.watch<CartModel>();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: purchase.products.length,
      itemBuilder: (context, index) {
        var product = purchase.products[index];
        String itemTitle = '${product.name} ${product.color}';
        String itemSubtitle =
            '${product.price} ₴ x ${product.quantity} = ${product.price * product.quantity} ₴';
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
          title: Text(itemTitle),
          subtitle: Text(
            itemSubtitle,
          ),
        );
      },
    );
  }
}