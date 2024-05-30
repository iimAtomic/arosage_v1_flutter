import 'package:arosagev1_flutter/views/ProfilePage.dart';
import 'package:arosagev1_flutter/views/arosage.dart';
import 'package:arosagev1_flutter/views/map.dart';
import 'package:arosagev1_flutter/views/plantesPage.dart';
import 'package:arosagev1_flutter/services/auth_serv.dart';
import 'package:flutter/material.dart';
import 'message_page.dart';
import 'plantes_feed_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/plante3.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.feed),
            title: const Text('Fil d\'actulaité'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const PlantesFeed(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('A\'rosage c\'est quoi ?'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ArosagePage(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Message'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MessagePage(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Ajout de plante'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const PlantesPage(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Mon profil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Carte'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MapPage(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Déconnexion'),
            onTap: () {
              Navigator.pop(context);
              logout(context);
            },
          ),
          // Ajoutez d'autres options de menu ici
        ],
      ),
    );
  }
}
