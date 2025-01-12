import 'package:etrick/constants.dart';
import 'package:etrick/models/catalog_model.dart';
import 'package:etrick/services/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';

enum PictureQuality { low, high }

class StorageService {
  static final storage = FirebaseStorage.instance;

  static Future<String> getPicture({
    required CatalogItem item,
    required int pictureId,
    String? color,
    PictureQuality quality = PictureQuality.high,
  }) {
    color ??= item.colors.first;
    String path =
        'catalog/${item.category}/${item.id}/$color/${quality.name}/${pictureId + 1}.jpg';
    Utils.log('[getPicture] $path');
    return storage.ref().child(path).getDownloadURL();
  }

  static Future<int> getPicturesCount({
    required CatalogItem item,
    PictureQuality quality = PictureQuality.high,
    String? color,
  }) async {
    color ??= item.colors.first;
    String path = 'catalog/${item.category}/${item.id}/$color/${quality.name}';
    Utils.log('[getPicturesCount] $path');
    final Reference folderRef = storage.ref().child(path);
    final ListResult result = await folderRef.listAll();

    return result.items.length;
  }

  static downloadCatalogPictures(
    CatalogModel catalog,
    List<CatalogItem> items, [
    List<String>? categories,
  ]) async {
    categories ??= Constants.categories.keys.toList();
    List<CatalogItem> categoryItems =
        items.where((item) => categories!.contains(item.category)).toList();
    for (var item in categoryItems) {
      List<Pictures> pictures = [];
      await Future.forEach(item.colors, (color) async {
        int idLength = await getPicturesCount(item: item, color: color);
        List<String> urls = [];
        for (int i = 0; i < idLength; i++) {
          urls.add(await getPicture(item: item, pictureId: i, color: color));
        }
        pictures = [
          ...pictures,
          Pictures(color: color, urls: urls),
        ];
      });
      catalog.saveCatalogItem(item, pictures);
    }
  }
}
