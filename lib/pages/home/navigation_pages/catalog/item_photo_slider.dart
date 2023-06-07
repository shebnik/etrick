import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:etrick/models/catalog_model.dart';
import 'package:etrick/services/storage_service.dart';
import 'package:flutter/material.dart';

class ItemPhotoSlider extends StatefulWidget {
  const ItemPhotoSlider({
    super.key,
    required this.item,
    required this.quality,
    this.color,
  });

  final CatalogItem item;
  final PictureQuality quality;
  final String? color;

  @override
  State<ItemPhotoSlider> createState() => _ItemPhotoSliderState();
}

class _ItemPhotoSliderState extends State<ItemPhotoSlider> {
  late final CatalogItem item;
  late final PictureQuality quality;

  int photosCount = 0;
  ValueNotifier<int> currentCarouselIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    item = widget.item;
    quality = widget.quality;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      photosCount = await StorageService.getPicturesCount(
        item: item,
        quality: quality,
        color: widget.color,
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CarouselSlider(
            options: CarouselOptions(
              enlargeCenterPage: false,
              enableInfiniteScroll: false,
              initialPage: 0,
              autoPlay: false,
              onPageChanged: (index, reason) =>
                  currentCarouselIndex.value = index,
            ),
            items: List.generate(
              photosCount,
              (index) => FutureBuilder(
                future: StorageService.getPicture(
                  item: item,
                  pictureId: index,
                  quality: quality,
                  color: widget.color,
                ),
                builder: (_, snapshot) => snapshot.data == null
                    ? const SizedBox.shrink()
                    : CachedNetworkImage(
                        imageUrl: snapshot.data as String,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const SizedBox.shrink(),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.error),
                        ),
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder(
          valueListenable: currentCarouselIndex,
          builder: (_, value, __) => photosCount == 0
              ? const SizedBox.shrink()
              : DotsIndicator(
                  dotsCount: photosCount,
                  position: value,
                  decorator: const DotsDecorator(
                    spacing: EdgeInsets.all(10.0),
                  ),
                ),
        ),
      ],
    );
  }
}
