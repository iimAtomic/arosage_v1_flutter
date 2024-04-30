// ignore: file_names
/// api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/photo.dart';

class ApiService {
  final String _baseUrl = "http://localhost:3000";

  Future<List<Photo>> getPhotosOfPlant(int planteId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/plante/v2/images'),
      headers: {"planteId": "$planteId"},
    );

    if (response.statusCode == 200) {
      List<dynamic> photosJson = json.decode(response.body);
      return photosJson.map((photoJson) => Photo.fromJson(photoJson)).toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }
}
