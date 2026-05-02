import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sports_item.dart';
import 'package:path/path.dart'; // Helps get the filename

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

  Future<String?> uploadImage(String filePath) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/upload'),
      );

      // Attach the photo file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          filePath,
          filename: basename(filePath),
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        // The backend returns the URL of the image in Blob Storage[cite: 1]
        var responseData = await response.stream.bytesToString();
        var json = jsonDecode(responseData);
        return json['url'];
      } else {
        print("Upload failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
