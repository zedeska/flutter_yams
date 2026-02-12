import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Api {
  static const String _baseUrl = 'api.yams.tf';
  static const String _token = "";

  Future<Map<String, dynamic>> search(String query) async {
    final httpPackageUrl = Uri.https(_baseUrl, '/search', {'query': query});
    final httpPackageResponse = await http.get(httpPackageUrl);
    if (httpPackageResponse.statusCode != 200) {
      throw Exception('Failed to make request: ${httpPackageResponse.statusCode}');
    }
    final httpPackageJson = json.decode(httpPackageResponse.body) as Map<String, dynamic>;
    return httpPackageJson;
  }

  Future<File> downloadTrack(String title, String trackId, String platform) async {
    final httpPackageUrl = Uri.https(_baseUrl, '/play', {'id': trackId, 'p': platform == "qobuz" ? "1" : "0", 'token': _token, 'q':  '2'});
    final httpPackageResponse = await http.get(httpPackageUrl);
    if (httpPackageResponse.statusCode != 200) {
      throw Exception('Failed to make request: ${httpPackageResponse.body}');
    }
    
    // Get the document directory path
    final directory = await getDownloadsDirectory();
    // Validate or create a filename. Use generated ID or name if possible
    final filePath = '${directory?.path}/$title.flac';
    
    final file = File(filePath);
    return file.writeAsBytes(httpPackageResponse.bodyBytes);
  }
}