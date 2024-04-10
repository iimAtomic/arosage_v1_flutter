import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:arosagev1_flutter/models/photo.dart';
import 'package:arosagev1_flutter/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'custom_drawer.dart';

class PlantesFeed extends StatefulWidget {
  @override
  _PlantesPageState createState() => _PlantesPageState();
}

class _PlantesPageState extends State<PlantesFeed> {
  final _formKey = GlobalKey<FormState>();
  List<dynamic> _plantes = [];
  String _nom = '';
  String _desc = '';
  XFile? _image;

  @override
  void initState() {
    super.initState();
    _fetchPlantes();
  }

  Future<void> _fetchPlantes() async {
    var url = Uri.parse(
        'http://ec2-13-39-86-184.eu-west-3.compute.amazonaws.com/api/plante/v2/all');
    var response = await http.get(
      url
    );
    if (response.statusCode == 200) {
      print("il existe des plantes ");
      List<dynamic> plantesData = json.decode(response.body);

      // Clear the _plantes list before populating it with new data
      _plantes.clear();

      for (var planteData in plantesData) {
        var planteId = planteData["id"];
        var plantePhotos = await _fetchPlantePhotos(planteId);
        List<Map<String, dynamic>> photoDataList = [];
        for (var photo in plantePhotos) {
          photoDataList.add({
            "name": photo.name,
            "type": photo.type,
            "size": photo.size,
            "data": photo.data,
          });
        }
        _plantes.add({
          "id": planteId,
          "nom": planteData["nom"],
          "description": planteData["description"],
          "photoData": photoDataList,
        });
      }
      setState(() {});
    } else {
      print("Erreur lors de la récupération des plantes");
    }
  }

  Future<List<PhotoAro>> _fetchPlantePhotos(int planteId) async {
    var url = Uri.parse(
        'http://ec2-13-39-86-184.eu-west-3.compute.amazonaws.com/api/plante/v2/images');
    var response = await http.get(
      url,
      headers: {"planteId": planteId.toString()},
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<PhotoAro> photos = [];
      for (var item in jsonData) {
        photos.add(PhotoAro.fromJson(item));
      }
      return photos;
    } else {
      throw Exception("Error retrieving photos");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fil d\'actualité'),
        backgroundColor: Colors.blue, // Style Facebook
      ),
      body: ListView.builder(
        itemCount: _plantes.length,
        itemBuilder: (context, index) {
          var plante = _plantes[index];
          return PlantPostCard(
            nom: plante['nom'],
            description: plante['description'],
            imageData: plante['photoData'].isNotEmpty ? plante['photoData'][0]['data'] : null,
          );
        },
      ),
    );
  }
}

class PlantPostCard extends StatelessWidget {
  final String nom;
  final String description;
  final Uint8List? imageData;

  const PlantPostCard({
    Key? key,
    required this.nom,
    required this.description,
    this.imageData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person), // Remplacez par l'image de l'utilisateur si disponible
            ),
            title: Text(nom),
            subtitle: Text(description),
            trailing: Icon(Icons.more_vert),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(description),
          ),
          imageData != null
              ? Image.memory(imageData!)
              : Placeholder(fallbackHeight: 200), // Hauteur à ajuster
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton.icon(
                icon: Icon(Icons.thumb_up, color: Colors.blue),
                label: Text('J\'aime'),
                onPressed: () {
                  // Action pour 'J'aime'
                },
              ),
              TextButton.icon(
                icon: Icon(Icons.comment, color: Colors.grey),
                label: Text('Commentaire'),
                onPressed: () {
                  // Action pour commenter
                },
              ),
              TextButton.icon(
                icon: Icon(Icons.share, color: Colors.grey),
                label: Text('Partager'),
                onPressed: () {
                  // Action pour partager
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class PhotoAro {
  late String name;
  late String type;
  late int size;
  late Uint8List data;

  PhotoAro(
      {required this.name,
      required this.type,
      required this.size,
      required this.data});

  factory PhotoAro.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('data') && json['data'] != null) {
      try {
        // Decode the base64 encoded data to Uint8List
        Uint8List decodedData = base64.decode(json['data']);
        return PhotoAro(
          name: json['name'],
          type: json['type'],
          size: json['size'],
          data: decodedData,
        );
      } catch (e) {
        print('Error decoding base64 data: $e');
        // Return a default PhotoAro object with empty data if decoding fails
        return PhotoAro(
          name: json['name'],
          type: json['type'],
          size: json['size'],
          data: Uint8List(0), // Empty Uint8List
        );
      }
    } else {
      // Return a default PhotoAro object with empty data if 'data' field is missing or null
      return PhotoAro(
        name: json['name'],
        type: json['type'],
        size: json['size'],
        data: Uint8List(0), // Empty Uint8List
      );
    }
  }
}
