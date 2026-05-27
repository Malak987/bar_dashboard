import '../network/api_constants.dart';

/// Helper لبناء الـ full URL للصور
/// الباك إند بيرجّع:
///   - path نسبي: "/CategoryImages/xxx.png"  →  baseUrl + path
///   - URL كامل: "https://..."               →  يرجع زي ما هو
class ImageUrlHelper {
  static String? buildFullUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;

    // لو URL كامل بالفعل
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    // تنظيف الـ baseUrl وإضافة الـ path
    final base = ApiConstants.baseUrl.endsWith('/')
        ? ApiConstants.baseUrl.substring(0, ApiConstants.baseUrl.length - 1)
        : ApiConstants.baseUrl;

    final path = imagePath.startsWith('/') ? imagePath : '/$imagePath';

    return '$base$path';
  }
}
