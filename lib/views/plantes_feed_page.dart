import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'custom_dialog.dart';
import 'custom_drawer.dart';
import 'package:arosagev1_flutter/storage/storage.dart';
import 'package:arosagev1_flutter/views/ProfilePage.dart';

class PlantesFeed extends StatefulWidget {
  const PlantesFeed({super.key});

  @override
  _PlantesPageState createState() => _PlantesPageState();
}

class _PlantesPageState extends State<PlantesFeed> {
  final List<dynamic> _plantes = [];

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
        _plantes.add({
          "id": planteId,
          "nom": planteData["nom"],
          "description": planteData["description"],
          "prenomProprio": planteData["prenomProprio"],
          "pseudoProprio": planteData["pseudoProprio"],
          "photoData": plantePhotos,
        });
      }
      setState(() {});
    } else {
      if (kDebugMode) {
        print("Erreur lors de la récupération des plantes");
      }
    }
  }

  Future<List<Uint8List>> _fetchPlantePhotos(int planteId) async {
    var url = Uri.parse(
        'http://ec2-13-39-86-184.eu-west-3.compute.amazonaws.com/api/plante/v2/images');
    var response =
        await http.get(url, headers: {"planteId": planteId.toString()});
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<Uint8List> photos = [];
      for (var item in jsonData) {
        var photo = PhotoAro.fromJson(item);
        photos.add(photo.data);
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
        title: const Text('Plantes Feed'),
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
      ),
      drawer: const CustomDrawer(),
      body: ListView.builder(
        itemCount: _plantes.length,
        itemBuilder: (context, index) {
          var plante = _plantes[index];
          return PlantPostCard(
            nom: plante['nom'],
            description: plante['description'],
            imageData: plante['photoData'],
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
  final List<Uint8List> imageData;
  final int planteId;

  const PlantPostCard({
    Key? key,
    required this.nom,
    required this.description,
    required this.imageData,
    required this.prenom,
    required this.planteId,
  }) : super(key: key);

  @override
  _PlantPostCardState createState() => _PlantPostCardState();
}

class _PlantPostCardState extends State<PlantPostCard> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
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
    List<Commentaire> commentaires = [];
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      for (var item in jsonData) {
        commentaires.add(Commentaire.fromJson(item));
      }
    } else {
      if (kDebugMode) {
        print("Erreur lors de la récupération des commentaires");
      }
    }
    return commentaires;
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
    } else {
      throw Exception("Erreur lors de l'ajout du commentaire");
    }
  }

  void _submitComment() {
    if (_formKey.currentState!.validate()) {
      _ajouterConseil(widget.planteId, _commentController.text);
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(widget.nom),
            subtitle: Text(widget.prenom),
            trailing: const Icon(Icons.more_vert),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.description),
          ),
          if (widget.imageData.isNotEmpty)
            GestureDetector(
              onTap: () => _openGallery(context),
              child: CarouselSlider.builder(
                itemCount: widget.imageData.length,
                carouselController: _controller,
                options: CarouselOptions(
                    autoPlay: false,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
                itemBuilder: (context, index, realIndex) {
                  return Image.memory(widget.imageData[index], fit: BoxFit.cover);
                },
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.imageData.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4),
                  ),
                ),
              );
            }).toList(),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.thumb_up, color: Colors.blue),
                label: const Text('J\'aime'),
                onPressed: () {
                  // Add functionality for liking the post
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.comment, color: Colors.grey),
                label: const Text('Comment'),
                onPressed: () {
                  // Add functionality for commenting on the post
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.share, color: Colors.grey),
                label: const Text('Share'),
                onPressed: () {
                  // Add functionality for sharing the post
                },
              ),
            ],
          ),
          CommentBox(
            commentController: _commentController,
            formKey: _formKey,
            sendButtonMethod: _submitComment,
          ),
          FutureBuilder<List<Commentaire>>(
            future: _futureConseils,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data!.map((commentaire) {
                    return ListTile(
                      title: Text(commentaire.conseil),
                      subtitle: Text(commentaire.pseudo),
                    );
                  }).toList(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }

  void _openGallery(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: Text('Gallery')),
        body: PhotoViewGallery.builder(
          itemCount: widget.imageData.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: MemoryImage(widget.imageData[index]),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2,
            );
          },
          scrollPhysics: const BouncingScrollPhysics(),
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
        ),
      ),
    ));
  }
}

class CommentBox extends StatelessWidget {
  final TextEditingController commentController;
  final GlobalKey<FormState> formKey;
  final VoidCallback sendButtonMethod;

  const CommentBox({
    super.key,
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
            decoration: const InputDecoration(
              labelText: 'Commentaire',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: sendButtonMethod,
            child: const Text('Envoyer'),
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

class Commentaire {
  final String conseil;
  final String pseudo;

  Commentaire({
    required this.conseil,
    required this.pseudo,
  });

  factory Commentaire.fromJson(Map<String, dynamic> json) {
    return Commentaire(
      conseil: json['conseil'],
      pseudo: json['nom'],
    );
  }
}
