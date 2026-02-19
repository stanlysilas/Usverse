import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

class B2StorageService {
  static const String keyId = '';
  static const String applicationKey = '';
  static const String bucketId = '';

  String? authToken;
  String? apiUrl;
  String? downloadUrl;

  Future<void> authorize() async {
    final credentials = base64Encode(utf8.encode('$keyId:$applicationKey'));

    final response = await http.get(
      Uri.parse('https://api.backblazeb2.com/b2api/v2/b2_authorize_account'),
      headers: {'Authorization': 'Basic $credentials'},
    );

    final data = jsonDecode(response.body);

    authToken = data['authorizationToken'];
    apiUrl = data['apiUrl'];
    downloadUrl = data['downloadUrl'];
  }

  Future<Map<String, dynamic>> getUploadUrl() async {
    final response = await http.post(
      Uri.parse('$apiUrl/b2api/v2/b2_get_upload_url'),
      headers: {'Authorization': authToken!},
      body: jsonEncode({'bucketId': bucketId}),
    );

    return jsonDecode(response.body);
  }

  Future<String> uploadFile(File file) async {
    if (authToken == null) {
      await authorize();
    }

    final uploadData = await getUploadUrl();

    final uploadUrl = uploadData['uploadUrl'];
    final uploadAuthToken = uploadData['authorizationToken'];

    final bytes = await file.readAsBytes();

    final fileName = 'memories/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

    await http.post(
      Uri.parse(uploadUrl),
      headers: {
        'Authorization': uploadAuthToken,
        'X-Bz-File-Name': Uri.encodeComponent(fileName),
        'Content-Type': mimeType,
        'X-Bz-Content-Sha1': 'do_not_verify',
      },
      body: bytes,
    );

    return '$downloadUrl/file/usverse-memories/$fileName';
  }
}
