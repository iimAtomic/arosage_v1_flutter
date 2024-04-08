// plante_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plante.dart';

final Uri apiUri = Uri.parse("http://localhost:3000/api/plante/v2/images");

class PlanteService {
  Future<List<Plante>> fetchPlantes() async {
    var response = await http.get(apiUri);
    if (response.statusCode == 200) {
      List<dynamic> plantesJson = json.decode(response.body);
      return plantesJson.map((json) => Plante.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load plantes');
    }
  }
}
