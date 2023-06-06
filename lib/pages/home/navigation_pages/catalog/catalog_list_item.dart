import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:etrick/constants.dart';
import 'package:etrick/models/cart_model.dart';
import 'package:etrick/models/catalog_model.dart';
import 'package:etrick/services/storage_service.dart';
import 'package:etrick/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CatalogListItem extends StatefulWidget {
  final int index;

  const CatalogListItem({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<CatalogListItem> createState() => _CatalogListItemState();
}

class _CatalogListItemState extends State<CatalogListItem> {
  late CatalogItem item;
  ValueNotifier<int> photosCount = ValueNotifier(0);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      photosCount.value = await StorageService.getPicturesCount(item);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    item = context.select<CatalogModel, CatalogItem>(
      (catalog) => catalog.getByPosition(widget.index),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: photosCount,
                builder: (_, value, __) => ItemPhotosSlider(
                  item: item,
                  photosCount: value,
                ),
              ),
            ),
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${item.price} грн.',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            _AddToCartWidget(item: item),
          ],
        ),
      ),
    );
  }
}

class ItemPhotosSlider extends StatefulWidget {
  const ItemPhotosSlider({
    super.key,
    required this.item,
    required this.photosCount,
  });

  final CatalogItem item;
  final int photosCount;

  @override
  State<ItemPhotosSlider> createState() => _ItemPhotosSliderState();
}

class _ItemPhotosSliderState extends State<ItemPhotosSlider> {
  ValueNotifier<int> currentCarouselIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            enlargeCenterPage: false,
            enableInfiniteScroll: false,
            initialPage: 0,
            autoPlay: false,
            onPageChanged: (index, reason) =>
                currentCarouselIndex.value = index,
          ),
          items: List.generate(
            widget.photosCount,
            (index) => FutureBuilder(
              future: StorageService.getPicture(widget.item, index),
              builder: (_, snapshot) => snapshot.data == null
                  ? const Center(child: CircularProgressIndicator())
                  : CachedNetworkImage(
                      imageUrl: snapshot.data as String,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.error),
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder(
          valueListenable: currentCarouselIndex,
          builder: (_, value, __) => value == 0
              ? const SizedBox.shrink()
              : DotsIndicator(
                  dotsCount: widget.photosCount,
                  position: value,
                  decorator: DotsDecorator(
                    size: const Size.square(8),
                    activeSize: const Size(16, 8),
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _AddToCartWidget extends StatelessWidget {
  final CatalogItem item;

  const _AddToCartWidget({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isInCart = context.select<CartModel, bool>(
      (cart) => cart.items.contains(item),
    );

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey,
          width: 2,
        ),
      ),
      child: IconButton(
        iconSize: 32,
        icon: Icon(
          isInCart ? Icons.shopping_cart : Icons.shopping_cart_outlined,
          color: isInCart ? AppTheme.primaryColor : Colors.grey,
        ),
        onPressed: isInCart
            ? () => context.push(Constants.cartLoc)
            : () => context.read<CartModel>().add(item),
      ),
    );
  }
}
