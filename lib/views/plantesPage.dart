import 'dart:convert';
import 'dart:io';
import 'package:arosagev1_flutter/storage/storage.dart';
import 'package:arosagev1_flutter/views/ProfilePage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'custom_drawer.dart';

class PlantesPage extends StatefulWidget {
  const PlantesPage({super.key});

  @override
  _PlantesPageState createState() => _PlantesPageState();
}

class _PlantesPageState extends State<PlantesPage> {
  final _formKey = GlobalKey<FormState>();
  final List<dynamic> _plantes = [];
  String _nom = '';
  String _desc = '';
  List<XFile>? _images;

  @override
  void initState() {
    super.initState();
    _fetchPlantes();
  }

  Future<void> _fetchPlantes() async {
    var url = Uri.parse(
        'http://ec2-54-163-5-132.compute-1.amazonaws.com/api/user/v1/plante');
    var pseudo = await SecureStorage().readSecureData("pseudo");
    var jwt = await SecureStorage().readSecureData("jwt_token");

    var response = await http.get(
      url,
      headers: {
        "pseudo": pseudo,
        "Authorization": "Bearer $jwt",
      },
    );
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("il existe des plantes ");
      }
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
          "nom": Uri.decodeComponent(planteData["nom"]),
          "description": Uri.decodeComponent(planteData["description"]),
          "photoData": photoDataList,
        });
      }
      setState(() {});
    } else {
      if (kDebugMode) {
        print("Erreur lors de la récupération des plantes");
      }
    }
  }

  Future<List<PhotoAro>> _fetchPlantePhotos(int planteId) async {
    var url = Uri.parse(
        'http://ec2-54-163-5-132.compute-1.amazonaws.com/api/plante/v2/images');
    var jwt = await SecureStorage().readSecureData("jwt_token");
    var response = await http.get(
      url,
      headers: {
        "planteId": planteId.toString(),
        "Authorization": "Bearer $jwt",
      },
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
    var url = Uri.parse(
        'http://ec2-54-163-5-132.compute-1.amazonaws.com/api/plante/v2/add');
    var pseudo = await SecureStorage().readSecureData("pseudo");
    var password = await SecureStorage().readSecureData("password");
    var jwt = await SecureStorage().readSecureData("jwt_token");

    var request = http.MultipartRequest("POST", url)
      ..headers['nom'] = Uri.encodeComponent(_nom)
      ..headers['desc'] = Uri.encodeComponent(_desc)
      ..headers['pseudo'] = pseudo
      ..headers['userPwd'] = password
      ..headers['authorization'] = "Bearer $jwt";

    if (_images != null) {
      for (var file in _images!) {
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
      }
    }

    var response = await request.send();
    if (kDebugMode) {
      print(response.statusCode);
    }

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("Plante ajoutée avec succès");
      }
      _fetchPlantes();
    } else {
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
    final ImagePicker picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () async {
                  final List<XFile>? images = await picker.pickMultiImage();
                  if (images != null) {
                    setState(() {
                      _images = images;
                    });
                    Navigator.of(context).pop();
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () async {
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      _images = [image];
                    });
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/plante3.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ],
        ),
        title: const Text(
          'Mes plantes',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ));
            },
          ),
        ],
        iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 255, 255, 255), opacity: 1),
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Nom de la plante',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) => _nom = value!,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer un nom';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) => _desc = value!,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer une description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            textStyle: const TextStyle(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text('Sélectionner une image'),
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              if (_images != null) {
                                _addPlante();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Veuillez sélectionner une image'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 206, 210, 214),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text('Ajouter'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ..._plantes.map((plante) {
                List<Widget> photos = [];
                if (plante['photoData'] != null) {
                  List<dynamic> photoDataList = plante['photoData'];
                  for (var photoData in photoDataList) {
                    Uint8List imageData = photoData['data'];
                    photos.add(Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Image.memory(imageData),
                    ));
                  }
                }
                return Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text(plante['nom']),
                    subtitle: Text(plante['description']),
                    leading: photos.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: photos.first,
                          )
                        : const Placeholder(),
                  ),
                );
              }).toList(),
            ],
          ),
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
        if (kDebugMode) {
          print('Error decoding base64 data: $e');
        }
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
