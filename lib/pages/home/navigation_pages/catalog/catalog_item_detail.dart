import 'package:etrick/models/cart_item.dart';
import 'package:etrick/models/catalog_model.dart';
import 'package:etrick/pages/home/home_app_bar.dart';
import 'package:etrick/widgets/add_to_cart.dart';
import 'package:etrick/pages/home/navigation_pages/catalog/item_photo_slider.dart';
import 'package:etrick/services/storage_service.dart';
import 'package:etrick/services/utils.dart';
import 'package:etrick/widgets/color_switcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CatalogItemDetail extends StatefulWidget {
  final CatalogItem item;
  const CatalogItemDetail({
    super.key,
    required this.item,
  });

  @override
  State<CatalogItemDetail> createState() => _CatalogItemDetailState();
}

class _CatalogItemDetailState extends State<CatalogItemDetail> {
  late final CatalogItem item;
  String selectedColor = '';

  @override
  void initState() {
    item = widget.item;
    selectedColor = item.colors.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: item.name,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            ItemPhotoSlider(
              key: Key("${item.id}-$selectedColor"),
              item: context
                      .watch<CatalogModel>()
                      .getCatalogItem(context, widget.item) ??
                  widget.item,
              quality: PictureQuality.high,
              color: selectedColor,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${widget.item.name} ${Utils.capitalize(selectedColor)}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'В наявності',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                      ),
                      Text(
                        Utils.formatPrice(item.price),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 32,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ],
                  ),
                  AddToCart(
                    item: CartItem.fromCatalogItem(item).copyWith(
                      color: selectedColor,
                    ),
                    colorCheck: true,
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Колір',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 14,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 8,
                children: List.generate(
                  item.colors.length,
                  (index) => ColorSwitcher(
                    color: item.colors[index],
                    isSelected: item.colors[index] == selectedColor,
                    onColorSelected: (color) {
                      if (selectedColor == color) return;
                      selectedColor = color;
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.item.description.replaceAll('\\n', '\n'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
