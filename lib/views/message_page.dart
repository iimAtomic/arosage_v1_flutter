import 'package:arosagev1_flutter/views/ProfilePage.dart';
import 'package:flutter/material.dart';

import 'custom_drawer.dart';


class MessagePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        flexibleSpace: Stack(
          fit: StackFit.expand, // ajouter cette ligne
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/plante3.jpg'), // chemin vers votre image
                  fit: BoxFit.cover, // ajustement de l'image
                ),
              ),
            ),
            Container(
              color:
                  Colors.black.withOpacity(0.5), // couleur sombre avec opacité
            ),
          ],
        ),
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.white, // couleur du titre
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
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 255, 255, 255), opacity: 1),
      ),
      drawer: const CustomDrawer(),
           
      body: ListView.separated(
        itemCount: 20, // Le nombre de messages factices à afficher
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/plante8.jpeg'), // Vérifiez que le chemin d'accès est correct
            ),
            title: Text('Nom de l\'expéditeur $index'),
            subtitle: Text('Extrait du message $index'),
            trailing: Text('${index % 12 + 1}:00 PM'),
            onTap: () {
              // Implémentez la navigation vers la page de détail du message si nécessaire
            },
          );
        },
      ),
    );
  }
}
