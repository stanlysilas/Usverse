import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

class CryptoService {
  static final _secureRandom = Random.secure();

  static String generateRelationshipKey() {
    final bytes = Uint8List(32);

    for (int i = 0; i < bytes.length; i++) {
      bytes[i] = _secureRandom.nextInt(256);
    }

    return base64Encode(bytes);
  }
}
