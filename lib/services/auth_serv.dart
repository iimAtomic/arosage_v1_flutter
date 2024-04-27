import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

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

Future<User> loginAWS(String pseudo , password) async {
  
  try{
    
    Response response = await get(
      Uri.parse('http://ec2-13-39-86-184.eu-west-3.compute.amazonaws.com/api/user/v1/get'),
      headers: {
        'pseudo' : pseudo,
        'pwd' : password
      }
    );
    print(response.statusCode);

    if(response.statusCode == 200){
      
      var data = jsonDecode(response.body.toString());
      print(data);
      print('Login successfully');
      return User.fromJson(jsonDecode(response.body));

    }else {
      print('failed');
    }
  }catch(e){
    print(e.toString());
  }
  throw Exception('Échec de la connexion');
}

class User {
  final String pseudo;
  final String nom;
  final String prenom;
  final String password;
  User({required this.pseudo, required this.nom, required this.prenom, required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      pseudo: json['pseudo'],
      nom: json['nom'],
      prenom: json['prenom'],
      password: json['pwd']
    );
  }
}
