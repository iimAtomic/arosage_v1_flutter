import 'package:flutter/material.dart';

List<BoxShadow> shadowList = [
  BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 1,
    blurRadius: 3,
    offset: const Offset(0, 2),
  ),
];

class ArosagePage extends StatefulWidget {
  const ArosagePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PageState createState() =>
      _PageState();
}

class _PageState extends State<ArosagePage> {
  bool showText =
      false; // Variable pour contrôler l'affichage de l'animation ou du texte

  @override
  void initState() {
    super.initState();
    // Démarrer un délai de 2 secondes avant de changer l'affichage à du texte
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showText = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('A\'rosage  C\'est quoi? '),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16.0), // Ajouter un padding autour du contenu
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          itemCount: 1, // Un seul article détaillé
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: showText ? 1.0 : 0.0,
                  child: const Text(
                    'A\'rosage   C\'est quoi?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: showText ? 1.0 : 0.0,
                  child: Container(
                    height: 240,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      image: const DecorationImage(
                        image: AssetImage(
                            'assets/plante8.jpeg'), // Replace with your image path
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: shadowList,
                    ),
                    margin: const EdgeInsets.only(top: 40),
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: showText ? 1.0 : 0.0,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                  child: const Text('Arosage est une application qui met en relation les propriétaires de plantes, les botanistes et les gardiens de plantes. L"application permet aux propriétaires de plantes de publier des photos et des informations sur leurs plantes, de poser des questions et de demander des conseils à la communauté. Les botanistes peuvent répondre aux questions et fournir des conseils d"entretien, tandis que les gardiens de plantes peuvent offrir leurs services pour arroser et prendre soin des plantes lorsque les propriétaires sont absents. Arosage offre également une fonctionnalité de messagerie privée pour permettre aux utilisateurs de communiquer entre eux. Les propriétaires de plantes peuvent contacter directement les botanistes pour obtenir des conseils personnalisés, tandis que les gardiens de plantes peuvent discuter avec les propriétaires pour organiser des séances d"arrosage. En somme, Arosage est une application de réseau social dédiée aux amoureux des plantes, qui leur permet de partager leur passion, d"obtenir des conseils d"experts et de trouver des gardiens de plantes fiables pour prendre soin de leurs plantes lorsqu"ils sont absents.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                    ),

                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
