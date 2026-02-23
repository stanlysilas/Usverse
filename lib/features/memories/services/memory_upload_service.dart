import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:usverse/core/crypto/encryption_service.dart';
import 'package:usverse/core/crypto/relationship_key_provider.dart';

class MemoryUploadService {
  static const cloudName = 'usverse-media';
  static const uploadPreset = 'usverse_unsigned';

  Future<Map<String, dynamic>> uploadMemory(Uint8List originalBytes) async {
    final compressed = await _compressImage(originalBytes);

    final key = await RelationshipKeyProvider.instance.getKey();

    final encrypted = await EncryptionService.instance.encryptBytes(
      data: compressed,
      key: key,
    );

    final imageUrl = await _uploadToCloud(encrypted.cipherText);

    return {
      'imageUrl': imageUrl,
      'nonce': base64Encode(encrypted.nonce),
      'mac': base64Encode(encrypted.mac),
    };
  }

  Future<Uint8List> _compressImage(Uint8List bytes) async {
    final result = await FlutterImageCompress.compressWithList(
      bytes,
      minWidth: 1280,
      minHeight: 1280,
      quality: 75,
      format: CompressFormat.jpeg,
    );

    return Uint8List.fromList(result);
  }

  Future<String> _uploadToCloud(Uint8List encryptedBytes) async {
    final uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/raw/upload",
    );

    final request = http.MultipartRequest('POST', uri);

    request.fields['upload_preset'] = uploadPreset;

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        encryptedBytes,
        filename: 'memory.enc',
      ),
    );

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception(
        'Upload failed (${response.statusCode}): ${response.body}',
      );
    }

    final json = jsonDecode(response.body);

    return json['secure_url'];
  }
}
