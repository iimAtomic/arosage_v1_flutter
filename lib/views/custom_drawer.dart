import 'package:arosagev1_flutter/views/plantesPage.dart';
import 'package:flutter/material.dart';
import 'MessagePage.dart';
import 'PlantesFeedPage.dart';
import 'connexion.dart';
import 'inscription.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),
          ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Plantes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MessagePage(),
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Connexion'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ));
              },
            ),
             ListTile(
              leading: Icon(Icons.login),
              title: Text('Inscription'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SignupPage(),
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.call),
              title: Text('Ajout de plante'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlantesPage(),
                ));
              },
            ),
             ListTile(
              leading: Icon(Icons.call),
              title: Text('Fil d:actulaité'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlantesListPage(),
                ));
              },
            ),
          // Ajoutez d'autres options de menu ici
        ],
      ),
    );
  }
}
