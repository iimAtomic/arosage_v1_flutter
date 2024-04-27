import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:arosagev1_flutter/models/photo.dart';
import 'package:arosagev1_flutter/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'custom_drawer.dart';

class PlantesPage extends StatefulWidget {
  @override
  _PlantesPageState createState() => _PlantesPageState();
}

class _PlantesPageState extends State<PlantesPage> {
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
        'http://ec2-13-39-86-184.eu-west-3.compute.amazonaws.com/api/user/v1/plante');

    var pseudo = await SecureStorage().readSecureData("pseudo");
    
    var response = await http.get(
      url,
      headers: {"pseudo": pseudo},
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

  Future<void> _addPlante() async {
    // Ajouter une nouvelle plante
    var url = Uri.parse(
        'http://ec2-13-39-86-184.eu-west-3.compute.amazonaws.com/api/plante/v2/add');
    
    var pseudo = await SecureStorage().readSecureData("pseudo");
    var password = await SecureStorage().readSecureData("password");


    var request = http.MultipartRequest("POST", url)
      ..headers['nom'] = _nom
      ..headers['desc'] = _desc
      ..headers['pseudo'] = pseudo
      ..headers['userPwd'] = password
      ..files.add(await http.MultipartFile.fromPath('file', _image!.path));
    var response = await request.send();
    print(response.statusCode);

    if (response.statusCode == 200) {
      print("Plante ajoutée avec succès");
      _fetchPlantes();
    } else {
      // Afficher l'erreur dans un SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Erreur lors de l\'ajout de la plante: ${response.reasonPhrase}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = image;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Aperçu de l'image"),
            content: Image.file(File(_image!.path)),
            actions: <Widget>[
              TextButton(
                child: const Text('Annuler'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Confirmer'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Ajoutez d'autres actions si nécessaire
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Plantes'),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Nom de la plante'),
                    onSaved: (value) => _nom = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un nom';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    onSaved: (value) => _desc = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer une description';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Sélectionner une image'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (_image != null) {
                          _addPlante();
                        } else {
                          _addPlante();
                          print("Veuillez sélectionner une image");
                        }
                      }
                    },
                    child: const Text('Ajouter'),
                  ),
                ],
              ),
            ),
            ..._plantes.map((plante) {
              List<Widget> photos = [];
              if (plante['photoData'] != null) {
                List<dynamic> photoDataList = plante['photoData'];
                for (var photoData in photoDataList) {
                  Uint8List imageData = photoData['data'];
                  photos.add(Image.memory(imageData));
                }
              }
              return ListTile(
                title: Text(plante['nom']),
                subtitle: Text(plante['description']),
                leading: photos.isNotEmpty
                    ? photos.first
                    : Placeholder(), // Display first photo or Placeholder if no photo
              );
            }).toList(),
          ],
        ),
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
