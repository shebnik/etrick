import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etrick/models/app_user.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _usersCollectionPath = 'users';

  // Collection references
  static final CollectionReference<AppUser> _users =
      _firestore.collection(_usersCollectionPath).withConverter(
            fromFirestore: (snapshot, _) =>
                AppUser.fromMap(snapshot.data() as Map<String, dynamic>),
            toFirestore: (user, _) => user.toMap(),
          );

  static Future<bool> updateUser(AppUser user) {
    return _users
        .doc(user.id)
        .update(user.toMap())
        .then((value) => true)
        .catchError((error) {
      print('[updateUser] Error: $error');
      return false;
    });
  }

  static Future<AppUser?> getUserById(String uid) {
    return _users
        .doc(uid)
        .get()
        .then((value) => value.data() as AppUser)
        .catchError((error) {
      print('[getUserById] Error: $error');
      return null;
    });
  }

  static Future<bool> createUser(AppUser appUser) async {
    try {
      await _users.doc(appUser.id).set(appUser);
      return true;
    } catch (e) {
      print('[createUser] Error: $e');
      return false;
    }
  }
}
