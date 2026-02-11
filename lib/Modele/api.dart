import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:async';

class Api {
  static const String _baseUrl = 'api.yams.tf';

  Future<Map<String, dynamic>> search(String query) async {
    final httpPackageUrl = Uri.https(_baseUrl, '/search', {'query': query});
    final httpPackageResponse = await http.get(httpPackageUrl);
    if (httpPackageResponse.statusCode != 200) {
      throw Exception('Failed to make request: ${httpPackageResponse.statusCode}');
    }
    final httpPackageJson = json.decode(httpPackageResponse.body) as Map<String, dynamic>;
    return httpPackageJson;
  }
}