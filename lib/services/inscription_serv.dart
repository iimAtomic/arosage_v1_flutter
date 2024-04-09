import 'dart:convert';

import 'package:arosagev1_flutter/services/auth_serv.dart';
import 'package:arosagev1_flutter/storage/storage.dart';
import 'package:http/http.dart' as http;

class UserController {
  static const String _baseUrl = 'http://ec2-13-39-86-184.eu-west-3.compute.amazonaws.com/api/user/v1/add';

  static Future<void> addUser(String nom, String prenom, String pseudo, String email, String rue, String codeRole, String nomVille, String codePostale, String pwd) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'nom': nom,
          'prenom': prenom,
          'pseudo': pseudo,
          'email': email,
          'rue': rue,
          'codeRole': codeRole,
          'nomVille': nomVille,
          'codePostale': codePostale,
          'pwd': pwd,
        },
      );
      if (response.statusCode == 200) {
        print('Utilisateur créé avec succès');
        var data = jsonDecode(response.body.toString());
        print(data);
        var user = User.fromJson(jsonDecode(response.body));
        SecureStorage().writeSecureData("pseudo", user.pseudo);
        SecureStorage().writeSecureData("password", user.password);
        print("read pseudo : ");
        SecureStorage().readSecureData("pseudo");
        print("read password : ");
        SecureStorage().readSecureData("password");
        print("Session credentials saved : ");
      } else {
        print('Échec de la création de l\'utilisateur: ${response.body}');
      }
    } catch (e) {
      print('Erreur lors de la communication avec le serveur: $e');
    }
  }
}
