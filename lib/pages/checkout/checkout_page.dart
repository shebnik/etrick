import 'dart:math';

import 'package:etrick/models/app_user.dart';
import 'package:etrick/models/cart_model.dart';
import 'package:etrick/models/purchase.dart';
import 'package:etrick/services/firestore_service.dart';
import 'package:etrick/services/utils.dart';
import 'package:etrick/widgets/app_snackbar.dart';
import 'package:etrick/widgets/item_card.dart';
import 'package:etrick/widgets/phone_input.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  ValueNotifier<bool> selfDelivery = ValueNotifier<bool>(true);

  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  ValueNotifier<bool> isAddreesError = ValueNotifier<bool>(false);
  ValueNotifier<bool> isphoneNumberError = ValueNotifier<bool>(false);

  Future<void> _placeOrder() async {
    isAddreesError.value = false;
    isphoneNumberError.value = false;
    if (!selfDelivery.value) {
      isAddreesError.value = !Utils.validateAddress(addressController.text);
      if (isAddreesError.value) {
        ScaffoldMessenger.of(context).showSnackBar(
          AppSnakbar(text: 'Введіть адресу').snackbar,
        );
        return;
      }
    }
    var userModel = context.read<AppUserModel>();
    if (userModel.user!.phoneNumber == null) {
      isphoneNumberError.value =
          !Utils.validatePhoneNumber(phoneNumberController.text);
      if (isphoneNumberError.value) {
        ScaffoldMessenger.of(context).showSnackBar(
          AppSnakbar(text: 'Введіть номер телефону').snackbar,
        );
        return;
      }
      userModel.user = userModel.user!
          .copyWith(phoneNumber: "+380${phoneNumberController.text}");
      await FirestoreService.updateUser(userModel.user!);
    }
    if (!mounted) return;
    var cart = context.read<CartModel>();
    final purchase = Purchase(
      purchaseId: Random().nextInt(1000000).toString(),
      products: cart.items,
      totalPrice: cart.totalPrice,
      selfDelivery: selfDelivery.value,
      address: addressController.text == ''
          ? 'Cамовивіз м. Миколаїв, вул. Новобузька 128'
          : addressController.text.trim(),
    );
    userModel.user = userModel.user!.copyWith(
      purchases: [...userModel.user!.purchases, purchase],
    );
    await FirestoreService.addPurchase(userModel.user!.id, purchase);
    cart.clear();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      AppSnakbar(text: 'Замовлення оформлено').snackbar,
    );
    while (context.canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<CartModel>();
    var user = context.watch<AppUserModel>().user!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оформлення замовлення'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Замовлення',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(cart.items.length, (index) {
            var item = cart.items[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ItemCard(
                item: item,
                canRemove: false,
              ),
            );
          }),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ValueListenableBuilder(
                valueListenable: selfDelivery,
                builder: (_, isSelfDelivery, __) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Спосіб доставки',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                    RadioListTile<bool>(
                      contentPadding: EdgeInsets.zero,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Самовивіз'),
                          if (isSelfDelivery)
                            const Text(
                              'м. Миколаїв, вул. Новобузька 128',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                        ],
                      ),
                      value: true,
                      groupValue: isSelfDelivery,
                      onChanged: (value) {
                        selfDelivery.value = value!;
                      },
                    ),
                    RadioListTile<bool>(
                      contentPadding: EdgeInsets.zero,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Доставка'),
                          if (!isSelfDelivery)
                            const Text(
                              'Нова пошта',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                        ],
                      ),
                      value: false,
                      groupValue: isSelfDelivery,
                      onChanged: (value) {
                        selfDelivery.value = value!;
                      },
                    ),
                    if (!isSelfDelivery)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ValueListenableBuilder(
                          valueListenable: isAddreesError,
                          builder: (_, error, __) => TextField(
                            key: const Key('address'),
                            controller: addressController,
                            decoration: InputDecoration(
                              hintText: 'Адреса доставки',
                              errorText: error ? 'Введіть адресу' : null,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Одержувач замовлення',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${user.firstName} ${user.lastName}${user.phoneNumber == null ? '' : "\n${user.phoneNumber}"}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  if (user.phoneNumber == null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ValueListenableBuilder(
                        valueListenable: isphoneNumberError,
                        builder: (_, error, __) => PhoneInput(
                          key: const Key('phone'),
                          phoneNumberController: phoneNumberController,
                          error: error,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Загальна сума замовлення',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Сума до оплати'),
                Text(
                  Utils.formatPrice(cart.totalPrice),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              onPressed: _placeOrder,
              child: const Text(
                'ЗАМОВЛЕННЯ ПІДТВЕРДЖУЮ',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
