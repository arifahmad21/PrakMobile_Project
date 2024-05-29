import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseNetwork {
  static final String baseUrl = "http://api.weatherapi.com/v1";

  static Future<Map<String, dynamic>?> get(String partUrl) async {
    final String fullUrl = "$baseUrl/$partUrl";
    try {
      final response = await http.get(Uri.parse(fullUrl));
      return _processResponse(response);
    } catch (e) {
      debugPrint("Error in BaseNetwork.get: $e");
      return null;
    }
  }

  static Map<String, dynamic>? _processResponse(http.Response response) {
    if (response.statusCode == 200) {
      final body = response.body;
      if (body.isNotEmpty) {
        return json.decode(body) as Map<String, dynamic>;
      }
    }
    debugPrint("Error: Received response with status code ${response.statusCode}");
    return null;
  }

  static void debugPrint(String value) {
    print("[BASE_NETWORK] - $value");
  }
}