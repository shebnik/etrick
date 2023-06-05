class Constants {
  static const appName = 'eTrick';
  static const logoAssetPath = 'assets/images/logo.png';

  static const homeLoc = '/';
  static const createAccountLoc = '/create-account';
  static const loginLoc = '/login';
  static const resetPasswordLoc = '/reset-password';
  static const cartLoc = '/cart';

  static const Map<String, String> categories = {
    'headsets': 'Bluetooth-гарнітури',
    'protect_skin': 'Захисні плівки та скло',
    'cases': 'Чохли',
    'chargers': 'Зарядні пристрої',
    'auto_holders': 'Тримачі',
    // 'cables': 'Кабелі',
  };

  static String getCategoryAsset(String category) =>
      'assets/images/categories/$category.jpg';
}
