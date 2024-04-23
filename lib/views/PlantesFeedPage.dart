import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
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

  @override
  void initState() {
    super.initState();
    _fetchPlantes();
  }

  Future<void> _fetchPlantes() async {
    var url = Uri.parse(
        'http://ec2-13-39-86-184.eu-west-3.compute.amazonaws.com/api/plante/v2/all');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> plantesData = json.decode(response.body);
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
          "prenomProprio": planteData["prenomProprio"],
          "pseudoProprio": planteData["pseudoProprio"],
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
    var response =
        await http.get(url, headers: {"planteId": planteId.toString()});
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
        backgroundColor: Colors.blue,
      ),
      drawer: CustomDrawer(),
      body: ListView.builder(
        itemCount: _plantes.length,
        itemBuilder: (context, index) {
          var plante = _plantes[index];
          return PlantPostCard(
            nom: plante['nom'],
            description: plante['description'],
            imageData: plante['photoData'].isNotEmpty
                ? plante['photoData'][0]['data']
                : null,
            prenom: plante['prenomProprio'],
            planteId: plante['id'],
          );
        },
      ),
    );
  }
}

class PlantPostCard extends StatefulWidget {
  final String nom;
  final String description;
  final String prenom;
  final Uint8List? imageData;
  final int planteId;

  const PlantPostCard({
    Key? key,
    required this.nom,
    required this.description,
    this.imageData,
    required this.prenom,
    required this.planteId,
  }) : super(key: key);

  @override
  _PlantPostCardState createState() => _PlantPostCardState();
}

class _PlantPostCardState extends State<PlantPostCard> {
  final TextEditingController _commentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<Commentaire>> _futureConseils;

  @override
  void initState() {
    super.initState();
    _futureConseils = _fetchConseils(widget.planteId);
  }

  Future<List<Commentaire>> _fetchConseils(int planteId) async {
    var url = Uri.parse(
        'http://ec2-13-39-86-184.eu-west-3.compute.amazonaws.com/api/plante/v2/conseils');
    var response =
        await http.get(url, headers: {"planteId": planteId.toString()});
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<Commentaire> commentaires = [];
      for (var item in jsonData) {
        commentaires.add(Commentaire.fromJson(item));
      }

      print(commentaires);
      return commentaires;
    } else {
      throw Exception("Error retrieving comments");
    }
  }

  Future<void> _ajouterConseil(int planteId, String conseil) async {
    var url = Uri.parse(
        'http://ec2-13-39-86-184.eu-west-3.compute.amazonaws.com/api/plante/v2/botaniste/conseil/add');
    var pseudo = await SecureStorage().readSecureData("pseudo");
    var password = await SecureStorage().readSecureData("password");
    var response = await http.post(
      url,
      headers: {
        "botanistePseudo": pseudo,
        "pwd": password,
        "planteId": planteId.toString(),
        "conseil": conseil,
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        _futureConseils = _fetchConseils(planteId);
      });

      print(pseudo);
      print(planteId);
      print(conseil);
    } else {
      // DEBUG LUX
      print(pseudo);
      print(planteId);
      print(conseil);

      throw Exception("Error adding comment");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(widget.nom),
            subtitle: Text(widget.prenom),
            trailing: Icon(Icons.more_vert),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.description),
          ),
          widget.imageData != null
              ? Image.memory(widget.imageData!)
              : Placeholder(fallbackHeight: 200),
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
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: CommentBox(
                          sendButtonMethod: () {
                            if (_formKey.currentState!.validate()) {
                              _ajouterConseil(
                                widget.planteId,
                                _commentController.text,
                              );
                              _commentController.clear();
                              Navigator.of(context).pop();
                            }
                          },
                          formKey: _formKey,
                          commentController: _commentController,
                        ),
                      );
                    },
                  );
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

class CommentBox extends StatelessWidget {
  final TextEditingController commentController;
  final GlobalKey<FormState> formKey;
  final VoidCallback sendButtonMethod;

  CommentBox({
    required this.commentController,
    required this.formKey,
    required this.sendButtonMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: commentController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un commentaire';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Commentaire',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: sendButtonMethod,
            child: Text('Envoyer'),
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

  PhotoAro({
    required this.name,
    required this.type,
    required this.size,
    required this.data,
  });

  factory PhotoAro.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('data') && json['data'] != null) {
      try {
        Uint8List decodedData = base64.decode(json['data']);
        return PhotoAro(
          name: json['name'],
          type: json['type'],
          size: json['size'],
          data: decodedData,
        );
      } catch (e) {
        print('Error decoding base64 data: $e');
        return PhotoAro(
          name: json['name'],
          type: json['type'],
          size: json['size'],
          data: Uint8List(0),
        );
      }
    } else {
      return PhotoAro(
        name: json['name'],
        type: json['type'],
        size: json['size'],
        data: Uint8List(0),
      );
    }
  }
}

class Commentaire {
  final int planteId;
  final String conseil;
  final String pseudo;

  Commentaire({
    required this.planteId,
    required this.conseil,
    required this.pseudo,
  });

  factory Commentaire.fromJson(Map<String, dynamic> json) {
    return Commentaire(
      planteId: json['planteId'],
      conseil: json['conseil'],
      pseudo: json[
          'pseudo'], // Remplacez 'pseudo' par le nom exact de l'attribut dans votre API
    );
  }
}
