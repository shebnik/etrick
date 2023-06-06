import 'package:etrick/models/catalog_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

enum PictureQuality { low, high }

class StorageService {
  static final storage = FirebaseStorage.instance;

  static Future<String> getPicture({
    required CatalogItem item,
    required int pictureId,
    PictureQuality quality = PictureQuality.high,
  }) {
    return storage
        .ref()
        .child(
            'catalog/${item.category}/${item.id}/${item.colors.first}/${quality.name}/${pictureId + 1}.jpg')
        .getDownloadURL();
  }

  static Future<int> getPicturesCount({
    required CatalogItem item,
    PictureQuality quality = PictureQuality.high,
    String? color,
  }) async {
    color ??= item.colors.first;
    final Reference folderRef = storage.ref().child(
          'catalog/${item.category}/${item.id}/$color/${quality.name}',
        );
    final ListResult result = await folderRef.listAll();

    return result.items.length;
  }
}
