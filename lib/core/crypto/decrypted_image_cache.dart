import 'dart:typed_data';

class DecryptedImageCache {
  DecryptedImageCache._();

  static final instance = DecryptedImageCache._();

  final _cache = <String, Uint8List>{};

  final int maxEntries = 30;

  Uint8List? get(String key) => _cache[key];

  void set(String key, Uint8List value) {
    _cache.remove(key);
    _cache[key] = value;

    if (_cache.length > maxEntries) {
      _cache.remove(_cache.keys.first);
    }
  }

  void clear() => _cache.clear();
}
