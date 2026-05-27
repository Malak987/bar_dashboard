/// 🌍 Helper لاستخراج إحداثيات GPS من نص العنوان
class GpsHelper {
  /// استخراج الـ lat و lng من نص العنوان
  static GpsCoordinates? extractFromAddress(String address) {
    // Regex بيدور على ?q=LAT,LNG في النص
    final regex = RegExp(
      r'[?&]q=(-?\d+\.?\d*),(-?\d+\.?\d*)',
      caseSensitive: false,
    );
    final match = regex.firstMatch(address);
    if (match != null) {
      final lat = double.tryParse(match.group(1) ?? '');
      final lng = double.tryParse(match.group(2) ?? '');
      if (lat != null && lng != null) {
        return GpsCoordinates(latitude: lat, longitude: lng);
      }
    }

    // محاولة تانية: إحداثيات: lat, lng
    final coordsRegex = RegExp(
      r'إحداثيات[:\s]*(-?\d+\.?\d*)[,\s]+(-?\d+\.?\d*)',
    );
    final m2 = coordsRegex.firstMatch(address);
    if (m2 != null) {
      final lat = double.tryParse(m2.group(1) ?? '');
      final lng = double.tryParse(m2.group(2) ?? '');
      if (lat != null && lng != null) {
        return GpsCoordinates(latitude: lat, longitude: lng);
      }
    }

    return null;
  }

  /// تنظيف العنوان من الـ GPS link (للعرض)
  static String cleanAddress(String address) {
    return address
        .replaceAll(
      RegExp(r'رابط الموقع[:\s]*https?://[^\s\n]+',
          caseSensitive: false),
      '',
    )
        .replaceAll(
      RegExp(r'https?://maps\.google\.com[^\s\n]*'),
      '',
    )
        .trim();
  }

  /// بناء Google Maps URL من إحداثيات
  static String buildGoogleMapsUrl(double lat, double lng) {
    return 'https://maps.google.com/?q=$lat,$lng';
  }
}

/// 🗺️ إحداثيات GPS
class GpsCoordinates {
  final double latitude;
  final double longitude;

  const GpsCoordinates({
    required this.latitude,
    required this.longitude,
  });

  /// Google Maps URL (للـ QR Code)
  String get googleMapsUrl =>
      'https://maps.google.com/?q=$latitude,$longitude';

  /// عرض مختصر للإحداثيات
  String get displayShort =>
      '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';

  @override
  String toString() => 'GPS($latitude, $longitude)';
}