import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etrick/models/app_user.dart';
import 'package:etrick/models/catalog_model.dart';
import 'package:etrick/models/purchase.dart';
import 'package:etrick/services/utils.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _usersCollectionPath = 'users';
  static const String _catalogCollectionPath = 'catalog';

  // Collection references
  static final CollectionReference<AppUser> _users =
      _firestore.collection(_usersCollectionPath).withConverter(
            fromFirestore: (snapshot, _) =>
                AppUser.fromMap(snapshot.data() as Map<String, dynamic>),
            toFirestore: (user, _) => user.toMap(),
          );

  static final CollectionReference<CatalogItem> _catalog =
      _firestore.collection(_catalogCollectionPath).withConverter(
            fromFirestore: (snapshot, _) =>
                CatalogItem.fromMap(snapshot.data() as Map<String, dynamic>),
            toFirestore: (catalogItem, _) => catalogItem.toMap(),
          );

  static Future<bool> updateUser(AppUser user) {
    return _users
        .doc(user.id)
        .update(user.toMap())
        .then((value) => true)
        .catchError((error) {
      Utils.log('[updateUser] Error: $error');
      return false;
    });
  }

  static Future<AppUser?> getUserById(String uid) {
    return _users
        .doc(uid)
        .get()
        .then((value) => value.data() as AppUser)
        .catchError((error) {
      Utils.log('[getUserById] Error: $error');
      return AppUser.empty();
    });
  }

  static Future<bool> createUser(AppUser appUser) async {
    try {
      await _users.doc(appUser.id).set(appUser);
      return true;
    } catch (e) {
      Utils.log('[createUser] Error: $e');
      return false;
    }
  }

  static Future<List<CatalogItem>> getCatalog() async {
    try {
      final catalog = await _catalog.get();
      return catalog.docs.map((e) => e.data()).toList();
    } catch (e) {
      Utils.log('[getCatalog] Error: $e');
      return [];
    }
  }

  static Future<bool> addPurchase(String uid, Purchase purchase) async {
    try {
      await _users.doc(uid).update({
        'purchases': FieldValue.arrayUnion([purchase.toMap()])
      });
      return true;
    } catch (e) {
      Utils.log('[addPurchase] Error: $e');
      return false;
    }
  }

}
