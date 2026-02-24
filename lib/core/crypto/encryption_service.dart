import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

class EncryptionResult {
  final Uint8List cipherText;
  final Uint8List nonce;
  final Uint8List mac;

  EncryptionResult({
    required this.cipherText,
    required this.nonce,
    required this.mac,
  });
}

class EncryptionService {
  EncryptionService._();

  static final EncryptionService instance = EncryptionService._();

  final _algorithm = AesGcm.with256bits();

  Future<EncryptionResult> encryptBytes({
    required Uint8List data,
    required Uint8List key,
  }) async {
    final secretKey = SecretKey(key);

    final nonce = _algorithm.newNonce();

    final secretBox = await _algorithm.encrypt(
      data,
      secretKey: secretKey,
      nonce: nonce,
    );

    return EncryptionResult(
      cipherText: Uint8List.fromList(secretBox.cipherText),
      nonce: Uint8List.fromList(secretBox.nonce),
      mac: Uint8List.fromList(secretBox.mac.bytes),
    );
  }

  Future<Uint8List> decryptBytes({
    required Uint8List cipherText,
    required Uint8List nonce,
    required Uint8List mac,
    required Uint8List key,
  }) async {
    final secretKey = SecretKey(key);

    final secretBox = SecretBox(cipherText, nonce: nonce, mac: Mac(mac));

    final clearText = await _algorithm.decrypt(secretBox, secretKey: secretKey);

    return Uint8List.fromList(clearText);
  }
}
