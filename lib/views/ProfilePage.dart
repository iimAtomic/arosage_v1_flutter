// ignore: file_names
import 'dart:convert';
import 'package:arosagev1_flutter/storage/storage.dart';
import 'package:arosagev1_flutter/views/custom_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _selectedImage;
  final List<dynamic> _plantes = [];
  String? _userPseudo;

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
      appBar: AppBar(
        title: const Text('Mon Profil' , style: TextStyle(
            color: Colors.white, 
          ),),
        backgroundColor: const Color(0xFF2C3438),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
         iconTheme: const IconThemeData(color: Color.fromARGB(255, 255, 255, 255), opacity: 1),
   
      ),
      drawer: const CustomDrawer(),
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
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/plante3.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 150,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage("assets/jardinier.jpg"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
                Text(
                  _userPseudo ?? 'Sukuna Doe',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const Text(
                  'CERTIFIED GARDEN DESTROYER',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildCategoryButton('PHOTOS'),
                    _buildCategoryButton('INFOS'),
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                      var imageData = photoDataList.isNotEmpty
                          ? photoDataList[0]['data']
                          : null;

                      return GestureDetector(
                        onTap: () => _toggleImage(imageData),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(imageData ?? ''),
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
                  child: const Icon(Icons.message, color: Colors.white),
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
      onPressed: () {
        // Implémentez la fonctionnalité du bouton ici
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        side: const BorderSide(color: Colors.grey),
      ),
      child: Text(title),
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
        if (kDebugMode) {
          print('Error decoding base64 data: $e');
        }
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
