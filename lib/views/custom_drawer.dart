import 'package:arosagev1_flutter/views/plantesPage.dart';
import 'package:flutter/material.dart';
import 'MessagePage.dart';
import 'PlantesFeedPage.dart';
import 'connexion.dart';
import 'inscription.dart';

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
              color: Colors.green,
            ),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home X'),
              onTap: () => Navigator.pop(context),
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
              leading: Icon(Icons.add),
              title: Text('Ajout de plante'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlantesPage(),
                ));
              },
            ),
             ListTile(
              leading: Icon(Icons.feed),
              title: Text('Fil d\'actulaité'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlantesFeed(),
                ));
              },
            ),
          // Ajoutez d'autres options de menu ici
        ],
      ),
    );
  }
}
