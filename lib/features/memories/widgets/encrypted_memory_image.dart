import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:usverse/core/crypto/decrypted_image_cache.dart';
import 'package:usverse/core/crypto/encryption_service.dart';
import 'package:usverse/core/crypto/relationship_key_provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class EncryptedMemoryImage extends StatefulWidget {
  final String imageUrl;
  final String nonce;
  final String mac;
  const EncryptedMemoryImage({
    super.key,
    required this.imageUrl,
    required this.nonce,
    required this.mac,
  });

  @override
  State<EncryptedMemoryImage> createState() => _EncryptedMemoryImageState();
}

class _EncryptedMemoryImageState extends State<EncryptedMemoryImage> {
  Uint8List? imageBytes;
  bool startedLoading = false;

  Future<void> _loadImage() async {
    if (startedLoading) return;
    startedLoading = true;

    final cached = DecryptedImageCache.instance.get(widget.imageUrl);

    if (cached != null) {
      setState(() => imageBytes = cached);
      return;
    }

    final response = await http.get(Uri.parse(widget.imageUrl));

    final encryptedBytes = response.bodyBytes;

    final key = await RelationshipKeyProvider.instance.getKey();

    final decrypted = await EncryptionService.instance.decryptBytes(
      cipherText: encryptedBytes,
      nonce: base64Decode(widget.nonce),
      mac: base64Decode(widget.mac),
      key: key,
    );

    DecryptedImageCache.instance.set(widget.imageUrl, decrypted);

    if (mounted) {
      setState(() => imageBytes = decrypted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.imageUrl),
      onVisibilityChanged: (info) {
        final size = info.size;

        debugPrint(size.toString());

        if (size.height <= 0 || size.width <= 0) return;

        if (info.visibleFraction > 0.1) {
          _loadImage();
        }
      },
      child: imageBytes == null
          ? const AspectRatio(
              aspectRatio: 1,
              child: Center(child: CircularProgressIndicator()),
            )
          : Image.memory(imageBytes!, fit: BoxFit.cover, gaplessPlayback: true),
    );
  }
}
