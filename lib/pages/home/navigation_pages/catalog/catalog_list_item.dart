import 'package:etrick/models/cart_item.dart';
import 'package:etrick/models/catalog_model.dart';
import 'package:etrick/widgets/add_to_cart.dart';
import 'package:etrick/pages/home/navigation_pages/catalog/catalog_item_detail.dart';
import 'package:etrick/pages/home/navigation_pages/catalog/item_photo_slider.dart';
import 'package:etrick/services/storage_service.dart';
import 'package:etrick/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CatalogListItem extends StatefulWidget {
  final String id;

  const CatalogListItem({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<CatalogListItem> createState() => _CatalogListItemState();
}

class _CatalogListItemState extends State<CatalogListItem> {
  late CatalogItem item;

  @override
  Widget build(BuildContext context) {
    item = context.select<CatalogModel, CatalogItem>(
      (catalog) => catalog.getById(widget.id)!,
    );

    return GestureDetector(
      onTap: () => Utils.showPageNoAnimation(
        context,
        CatalogItemDetail(item: item),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ItemPhotoSlider(
                  item: item,
                  quality: PictureQuality.low,
                ),
              ),
              Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8),
              Text(
                Utils.formatPrice(item.price),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AddToCart(
                    item: CartItem.fromCatalogItem(item),
                    colorCheck: false,
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
