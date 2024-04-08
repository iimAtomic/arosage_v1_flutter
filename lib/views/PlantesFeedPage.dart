// plantes_feed_page.dart
import 'package:flutter/material.dart';
import '../services/fetchImage.dart';
import '../models/plante.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlanteService {
  Future<List<Plante>> fetchPlantes(String pseudo) async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/user/v1/plante'),
      headers: {'pseudo': 'test'},
    );

    if (response.statusCode == 200) {
      List<dynamic> plantesJson = json.decode(response.body);
      print("Lux est un genie");
      return plantesJson.map((json) => Plante.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load plantes');
    }
  }
}
class PlantesListPage extends StatefulWidget {
  @override
  _PlantesListPageState createState() => _PlantesListPageState();
}

class _PlantesListPageState extends State<PlantesListPage> {
  late Future<List<Plante>> futurePlantes;

  @override
  void initState() {
    super.initState();
    futurePlantes = PlanteService().fetchPlantes('pseudoUtilisateur');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Plantes'),
      ),
      body: FutureBuilder<List<Plante>>(
        future: futurePlantes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Erreur: ${snapshot.error}");
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Plante plante = snapshot.data![index];
                return ListTile(
                  title: Text(plante.nom),
                  subtitle: Text(plante.description),
                  leading: Image.network(plante.imageUrl), // Affiche l'image à partir de l'URL
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
