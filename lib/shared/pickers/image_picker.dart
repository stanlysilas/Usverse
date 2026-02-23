import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

Future<Uint8List> pickImage(Uint8List selectedImage) async {
  final file = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (file == null) return selectedImage;

  final bytes = await file.readAsBytes();

  selectedImage = bytes;

  return selectedImage;
}
