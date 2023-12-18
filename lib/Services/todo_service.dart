import 'dart:convert';

import 'package:http/http.dart' as http;

class TodoService {
  static Future<bool> deleteById(String id) async {
    const url = "https://api.nstack.in/v1/todos/65807fa6cdf21a7c7e146458";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }

  static Future<List?> fetchToDo() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json["items"] as List;
      return result;
    } else {
      return null;
    }
  }

  static Future<bool> updateToDo(String id, Map body) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode == 200;
  }

  static Future<bool> addData(Map body) async {
     const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode == 201;
  }
}
