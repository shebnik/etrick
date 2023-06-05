
import 'package:carousel_slider/carousel_slider.dart';
import 'package:etrick/constants.dart';
import 'package:etrick/models/cart_model.dart';
import 'package:etrick/models/catalog_model.dart';
import 'package:etrick/services/storage_service.dart';
import 'package:etrick/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CatalogListItem extends StatefulWidget {
  final int index;

  const CatalogListItem(this.index, {Key? key}) : super(key: key);

  @override
  State<CatalogListItem> createState() => _CatalogListItemState();
}

class _CatalogListItemState extends State<CatalogListItem> {

  late CatalogItem item;
  ValueNotifier<int> photosCount = ValueNotifier(0);
  ValueNotifier<int> currentCarouselIndex = ValueNotifier(0);

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
              child: CarouselSlider(
                  options: CarouselOptions(
                    enlargeCenterPage: false,
                    enableInfiniteScroll: false,
                    initialPage: 0,
                    autoPlay: false,
                  ),
                  items: List.generate(
                    snapshot.data as int,
                    (index) => FutureBuilder(
                      future: StorageService.getPicture(item, index),
                      builder: (_, snapshot) => snapshot.data == null
                          ? CircularProgressIndicator()
                          : CachedNetworkImage(
                              imageUrl: snapshot.data as String,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Icon(Icons.error),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: item.photosURL.map((photoURL) {
                int index = item.photosURL.indexOf(photoURL);
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index ? Colors.black : Colors.grey,
                  ),
                );
              }).toList(),
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