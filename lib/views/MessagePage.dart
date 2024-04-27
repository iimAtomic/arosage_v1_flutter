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
        title: const Text('Messages'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
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
