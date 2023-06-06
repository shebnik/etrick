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

  @override
  void initState() {
    item = widget.item;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: item.name,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              ItemPhotoSlider(item: widget.item, quality: PictureQuality.high),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.item.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.item.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  Utils.formatPrice(item.price),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AddToCart(
                    item: item,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
