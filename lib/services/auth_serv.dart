import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:arosagev1_flutter/storage/storage.dart';
import 'dart:convert';

import 'package:http/http.dart';

Future<User> loginAWS(String pseudo, String password) async {
  final url = Uri.parse('http://127.0.0.1:3000/api/public/login');
  final secureStorage = SecureStorage();

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': pseudo, 'password': password}),
    );

    if (kDebugMode) {
      print('Response status code: ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());

      if (kDebugMode) {
        print('Response data: $data');
        print('Login successfully');
      }

      // Extraction du token JWT et des détails utilisateur
      if (data['jwt'] == null) {
        throw Exception('JWT token is missing');
      }

      String token = data['jwt'];
      await secureStorage.writeSecureData('jwt_token', token);

      // Extraction des détails utilisateur
      if (data['utilisateur'] == null) {
        throw Exception('User details are missing');
      }

      var userJson = data['utilisateur'];
      User user = User.fromJson(userJson);

      if (kDebugMode) {
        String? storedToken = await secureStorage.readSecureData('jwt_token');
        print('Stored token: $storedToken');
      }

      return user;
    } else {
      if (kDebugMode) {
        print('Failed with status code: ${response.statusCode}');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error: ${e.toString()}');
    }
  }
  throw Exception('Échec de la connexion');
}

class User {
  final String pseudo;
  final String nom;
  final String prenom;
  final String password;

  User({
    required this.pseudo,
    required this.nom,
    required this.prenom,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      pseudo: json['pseudo'] ?? 'Unknown',
      nom: json['nom'] ?? 'Unknown',
      prenom: json['prenom'] ?? 'Unknown',
      password: json['pwd'] ?? '',
    );
  }
}
