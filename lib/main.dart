import 'package:arosagev1_flutter/views/LoadingScreen.dart';
import 'package:arosagev1_flutter/views/Login.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AROSAGE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoadingScreen(), // Utilisez votre écran de chargement ici.
    );
  }
}
