// home_page.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/fetchImage.dart';
import '../models/photo.dart';

class PlantesFeed extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<PlantesFeed> {
  final ApiService _apiService = ApiService();
  List<Photo> _photos = [];

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  void _loadPhotos() async {
    try {
      final photos = await _apiService.getPhotosOfPlant(1); // Utilisez l'ID de plante approprié
      setState(() {
        _photos = photos;
      });
    } catch (e) {
      print("Failed to load photos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos comme publications FB'),
      ),
      body: ListView.builder(
        itemCount: _photos.length,
        itemBuilder: (context, index) {
          final photo = _photos[index];
          return ListTile(
            title: Text(photo.name),
            subtitle: Image.memory(base64Decode(photo.data)),
          );
        },
      ),
    );
  }
}
