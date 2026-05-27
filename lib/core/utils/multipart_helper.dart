import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;

class MultipartHelper {
  /// تحويل File (mobile/desktop) لـ MultipartFile
  static Future<MultipartFile> fileToMultipart(File file) async {
    final fileName = p.basename(file.path);
    final ext = p.extension(file.path).toLowerCase().replaceAll('.', '');
    return MultipartFile.fromFile(
      file.path,
      filename: fileName,
      contentType: _guessMediaType(ext),
    );
  }

  /// تحويل Bytes (web) لـ MultipartFile
  static MultipartFile bytesToMultipart(
      Uint8List bytes,
      String fileName,
      ) {
    final ext = p.extension(fileName).toLowerCase().replaceAll('.', '');
    return MultipartFile.fromBytes(
      bytes,
      filename: fileName.isEmpty ? 'image.png' : fileName,
      contentType: _guessMediaType(ext),
    );
  }

  static MediaType _guessMediaType(String ext) {
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'webp':
        return MediaType('image', 'webp');
      case 'gif':
        return MediaType('image', 'gif');
      default:
        return MediaType('image', 'png');
    }
  }
}

/// كلاس بيمثل صورة جاهزة للرفع (شغّال على Web و Mobile)
class PickedImageData {
  final Uint8List bytes;
  final String fileName;

  PickedImageData({required this.bytes, required this.fileName});

  MultipartFile toMultipart() =>
      MultipartHelper.bytesToMultipart(bytes, fileName);
}
