import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class MediaCompressor {
  MediaCompressor._();

  static Future<Uint8List> compressImage(
    Uint8List bytes, {
    int maxSizeMB = 10,
  }) async {
    final result = await FlutterImageCompress.compressWithList(
      bytes,
      minWidth: 1280,
      minHeight: 1280,
      quality: 75,
      format: CompressFormat.jpeg,
    );

    return Uint8List.fromList(result);
  }
}
