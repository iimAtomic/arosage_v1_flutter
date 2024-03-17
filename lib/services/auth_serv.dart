// auth_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> registerUser(Map<String, dynamic> userData) async {
  final url = Uri.parse('API LINK');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(userData),
  );

  // Vérifie si le code de statut est 200 OK ou 201 Created
  if (response.statusCode == 200 || response.statusCode == 201) {
    return true;
  } else {
    // affichage de la reponse en cas d'echec
    print('Erreur d\'inscription: ${response.body}');
    return false;
  }
}
