import 'package:arosagev1_flutter/views/ProfilePage.dart';
import 'package:flutter/material.dart';
// Assurez-vous d'avoir ce fichier avec le contenu nécessaire

class MessagePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Messages'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ));
            },
          ),
        ],
      ),
      drawer: Drawer(
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
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ));
              },
            ),
            // Ajoutez d'autres options de menu ici
          ],
        ),
      ),
      body: ListView.separated(
        itemCount: 20, // Le nombre de messages factices à afficher
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/plante8.jpeg'), // Vérifiez que le chemin d'accès est correct
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
