import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<User> login(String pseudo, String pwd) async {
  final response = await http.get(
    Uri.parse('http://172.30.96.1:3000/api/user/v1/get'),
    headers: {
      'pseudo': pseudo,
      'pwd': pwd,
    },
  );

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Échec de la connexion');
  }
}

class User {
  final String pseudo;
  final String nom;
  final String prenom;
  User({required this.pseudo, required this.nom, required this.prenom});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      pseudo: json['pseudo'],
      nom: json['nom'],
      prenom: json['prenom'],
    );
  }
}
