import 'package:etrick/models/catalog_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

enum PictureQuality { low, high }

class StorageService {
  static final storage = FirebaseStorage.instance;

  static Future<String> getPicture(CatalogItem item, int id) {
    return storage
        .ref()
        .child(
            'catalog/${item.category}/${item.id}/${item.colors.first}/${PictureQuality.low.name}/${id + 1}.jpg')
        .getDownloadURL();
  }

  static Future<int> getPicturesCount(CatalogItem item) async {
    final Reference folderRef = storage.ref().child(
        'catalog/${item.category}/${item.id}/${item.colors.first}/${PictureQuality.low.name}');

    final ListResult result = await folderRef.listAll();

    return result.items.length;
  }
}
