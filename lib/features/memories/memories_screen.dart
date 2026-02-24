import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:usverse/core/crypto/encryption_service.dart';
import 'package:usverse/core/crypto/relationship_key_provider.dart';
import 'package:usverse/shared/widgets/buttons/usverse_button.dart';
import 'package:usverse/shared/widgets/usverse_list_tile.dart';

class MemoriesScreen extends StatefulWidget {
  const MemoriesScreen({super.key});

  @override
  State<MemoriesScreen> createState() => _MemoriesScreenState();
}

class _MemoriesScreenState extends State<MemoriesScreen> {
  bool usverseListTileSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 800),
            child: UsverseButton(
              onSubmit: () async {
                final key = await RelationshipKeyProvider.instance.getKey();

                final original = Uint8List.fromList([1, 2, 3, 4, 5]);

                final encrypted = await EncryptionService.instance.encryptBytes(
                  data: original,
                  key: key,
                );

                final decrypted = await EncryptionService.instance.decryptBytes(
                  cipherText: encrypted.cipherText,
                  nonce: encrypted.nonce,
                  mac: encrypted.mac,
                  key: key,
                );

                debugPrint(decrypted.toString());
              },
              message: 'Test Encryption',
              color: Colors.red,
            ),
          ),

          UsverseListTile(
            title: 'Usverse List Tile',
            selected: false,
            extended: true,
            onTap: () {
              debugPrint('Selected Usverse ListTile');
            },
          ),
        ],
      ),
    );
  }
}
