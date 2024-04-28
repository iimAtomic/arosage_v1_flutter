import 'package:arosagev1_flutter/views/ProfilePage.dart';
import 'package:arosagev1_flutter/views/plantesPage.dart';
import 'package:flutter/material.dart';
import 'MessagePage.dart';
import 'PlantesFeedPage.dart';

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
          // Ajoutez d'autres options de menu ici
        ],
      ),
    );
  }
}
