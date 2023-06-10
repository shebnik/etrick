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
  late final String? color;

  int photosCount = 0;
  ValueNotifier<int> currentCarouselIndex = ValueNotifier(0);
  List<String> urls = [];

  @override
  void initState() {
    super.initState();
    item = widget.item;
    quality = widget.quality;
    color = widget.color;
    if (item.pictures != null) {
      if (color == null) {
        urls = item.pictures!.first.urls;
        photosCount = urls.length > 5 ? 5 : urls.length;
      } else {
        for (var picture in item.pictures!) {
          if (picture.color == color) {
            urls = picture.urls;
            break;
          }
        }
        photosCount = urls.length > 5 ? 5 : urls.length;
      }
      setState(() {});
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        photosCount = await StorageService.getPicturesCount(
          item: item,
          quality: quality,
          color: widget.color,
        );
        setState(() {});
      });
    }
  }

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
            photosCount,
            (index) {
              if (item.pictures != null) {
                return cachedImage(urls[index]);
              }
              return FutureBuilder(
                future: StorageService.getPicture(
                  item: item,
                  pictureId: index,
                  quality: quality,
                  color: widget.color,
                ),
                builder: (_, snapshot) {
                  return snapshot.data == null
                      ? const SizedBox.shrink()
                      : cachedImage(snapshot.data as String);
                },
              );
            },
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

  Widget cachedImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (context, url) => const SizedBox.shrink(),
      errorWidget: (context, url, error) => const Center(
        child: Icon(Icons.error),
      ),
    );
  }
}
