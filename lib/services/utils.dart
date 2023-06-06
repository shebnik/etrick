class Utils {
  static String formatPrice(double value) => "${value
      .toStringAsFixed(value.truncateToDouble() == value ? 0 : 2)
      .replaceAll(RegExp(r'\.00$'), '')
      .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match.group(1)} ')} ₴";
}
