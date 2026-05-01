import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sports_item.dart';

class ApiService {
  // We will replace this with your https://seusl-sports.azurewebsites.net later
  static const String baseUrl = 'YOUR_AZURE_FUNCTION_URL_HERE';

  Future<List<SportsItem>> fetchItems() async {
    final response = await http.get(Uri.parse('$baseUrl/api/items'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => SportsItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load sports equipment');
    }
  }
}