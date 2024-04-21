import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:arosagev1_flutter/models/photo.dart';
import 'package:arosagev1_flutter/storage/storage.dart';
import 'package:arosagev1_flutter/views/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:ui';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  List<dynamic> _plantes = [];
  String _nom = '';
  String _desc = '';
  String? _userPseudo;
  XFile? _image;

  @override
  void initState() {
    super.initState();
    _fetchUserPseudo();
    _fetchPlantes();
  }

  Future<void> _fetchUserPseudo() async {
    _userPseudo = await SecureStorage().readSecureData("pseudo");
    setState(() {}); // Update UI with retrieved pseudo
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

  void _toggleImage(String? imageUrl) {
    if (imageUrl != null) {
      setState(() {
        _selectedImage = imageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomDrawer(),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/plante3.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 150,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage("assets/SUKUNA.jpg"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 80),
                Text(
                 _userPseudo ?? 'Sukuna Doe',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Text(
                  'CERTIFIED GARDEN DESTROYER',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildCategoryButton('PHOTOS'),
                    _buildCategoryButton('INFOS'),
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount:
                        _plantes.length, // Use the length of your plants list
                    itemBuilder: (context, index) {
                      var plant = _plantes[index];
                      var photoDataList =
                          plant['photoData'] as List<Map<String, dynamic>>;
                      var imageUrl = photoDataList.isNotEmpty
                          ? photoDataList[0]['data']
                          : null; // Assuming 'data' holds the URL to the image

                      return GestureDetector(
                        onTap: () => _toggleImage(imageUrl),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(imageUrl ??
                                  ''), // Use NetworkImage for images from the network
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  color: Colors.green,
                  child: Icon(Icons.message, color: Colors.white),
                ),
              ],
            ),
            if (_selectedImage != null) ...[
            Positioned.fill(
              child: GestureDetector(
                onTap: () => _toggleImage(null),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.network(
                        _selectedImage!,
                        fit: BoxFit.contain,
                      ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String title) {
    return ElevatedButton(
      child: Text(title),
      onPressed: () {
        // Implémentez la fonctionnalité du bouton ici
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        side: BorderSide(color: Colors.grey),
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
