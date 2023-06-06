import 'package:etrick/models/cart_item.dart';
import 'package:etrick/models/catalog_model.dart';
import 'package:etrick/pages/home/home_app_bar.dart';
import 'package:etrick/pages/home/navigation_pages/catalog/add_to_cart.dart';
import 'package:etrick/pages/home/navigation_pages/catalog/item_photo_slider.dart';
import 'package:etrick/services/storage_service.dart';
import 'package:etrick/services/utils.dart';
import 'package:flutter/material.dart';

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
              item: widget.item,
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
                    item: CartItem.fromCatalogItem(item)
                        .copyWith(color: selectedColor),
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
                widget.item.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class ColorSwitcher extends StatefulWidget {
  final String color;
  final bool isSelected;
  final Function(String color) onColorSelected;

  const ColorSwitcher({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onColorSelected,
  });

  @override
  State<ColorSwitcher> createState() => _ColorSwitcherState();
}

class _ColorSwitcherState extends State<ColorSwitcher> {
  late bool isSelected;

  @override
  void initState() {
    isSelected = widget.isSelected;
    super.initState();
  }

  @override
  void didUpdateWidget(ColorSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      setState(() {
        isSelected = widget.isSelected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onColorSelected(widget.color),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Utils.getColorFromText(widget.color),
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                Text(
                  Utils.capitalize(widget.color),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
