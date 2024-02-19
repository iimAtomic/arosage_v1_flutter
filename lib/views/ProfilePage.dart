import 'package:flutter/material.dart';
import 'dart:ui'; // Importez dart:ui pour utiliser ImageFilter.blur

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _selectedImage;

  void _toggleImage(String? assetName) {
    setState(() {
      _selectedImage = assetName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/plante3.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 150,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage("assets/SUKUNA.jpg"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 80),
                Text(
                  'Sukuna Doe',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Text(
                  'CERTIFIED GARDEN DESTROYER',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildCategoryButton('PHOTOS'),
                    _buildCategoryButton('INFOS'),
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      String imageAsset = 'assets/plante${index + 1}.jpeg';
                      return GestureDetector(
                        onTap: () => _toggleImage(imageAsset),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(imageAsset),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  color: Colors.green,
                  child: Icon(Icons.message, color: Colors.white),
                ),
              ],
            ),
            if (_selectedImage != null) ...[
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => _toggleImage(null),
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          _selectedImage!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String title) {
    return ElevatedButton(
      child: Text(title),
      onPressed: () {
        // Implémentez la fonctionnalité du bouton ici
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        side: BorderSide(color: Colors.grey),
      ),
    );
  }
}
