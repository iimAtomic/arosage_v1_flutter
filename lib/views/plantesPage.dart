import 'dart:convert';
import 'dart:io';
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
    // Récupérer la liste des plantes
    var url = Uri.parse('http://localhost:3000/api/user/v1/plante');
    var response =
        await http.get(url, headers: {"idUser": "1", "pwd": "znlal"});
    if (response.statusCode == 200) {
      setState(() {
        _plantes = json.decode(response.body);
      });
    } else {
      print("Erreur lors de la récupération des plantes");
    }
  }

  Future<void> _addPlante() async {
    // Ajouter une nouvelle plante
    var url = Uri.parse('http://localhost:3000/api/plante/v2/add');
    var request = http.MultipartRequest("POST", url)
      ..fields['nom'] = _nom
      ..fields['desc'] = _desc
      ..headers['pseudo'] = 'ejnym'
      ..headers['userPwd'] = 'znlal'
      ..files.add(await http.MultipartFile.fromPath('file', _image!.path));
    var response = await request.send();
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
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
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
            ..._plantes
                .map((plante) => ListTile(
                      title: Text(plante['nom']),
                      subtitle: Text(plante['desc']),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
