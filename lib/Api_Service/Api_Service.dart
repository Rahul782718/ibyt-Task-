import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {

  /// GET Request
  static Future<dynamic> getRequest(String urlApi) async {
    final url = Uri.parse(urlApi);
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw ApiException('Failed to load data (${response.statusCode})');
      }
    } on SocketException {
      throw ApiException('No Internet connection');
    } on TimeoutException {
      throw ApiException('Request timed out');
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

}

