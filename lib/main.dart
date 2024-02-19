import 'package:flutter/material.dart';
import 'views/LoadingScreen.DART'; // Assurez-vous que le chemin d'importation est correct.

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mobi-lise',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoadingScreen(), // Utilisez votre écran de chargement ici.
    );
  }
}
