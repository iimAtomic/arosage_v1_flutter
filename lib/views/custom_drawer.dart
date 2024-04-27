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
              leading: const Icon(Icons.add),
              title: const Text('Ajout de plante'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlantesPage(),
                ));
              },
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
          // Ajoutez d'autres options de menu ici
        ],
      ),
    );
  }
}
