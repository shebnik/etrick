import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  late final SharedPreferences _instance;

  SharedPreferences get instance => _instance;

  SharedPreferencesProvider(SharedPreferences instance) {
    _instance = instance;
  }
}
