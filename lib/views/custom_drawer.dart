import 'package:arosagev1_flutter/views/plantesPage.dart';
import 'package:flutter/material.dart';
import 'MessagePage.dart';
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
              leading: const Icon(Icons.message),
              title: const Text('Messages'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Plantes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MessagePage(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Connexion'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ));
              },
            ),
             ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Inscription'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SignupPage(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.call),
              title: const Text('Plante Page'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlantesPage(),
                ));
              },
            ),
          // Ajoutez d'autres options de menu ici
        ],
      ),
    );
  }
}
