import 'package:flutter/material.dart';
import 'package:arosagev1_flutter/views/inscription.dart';

List<BoxShadow> shadowList = [
  BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 1,
    blurRadius: 3,
    offset: const Offset(0, 2),
  ),
];

class RgpdPage extends StatefulWidget {
  @override
  _RgpdPageState createState() => _RgpdPageState();
}

class _RgpdPageState extends State<RgpdPage> {
  bool _isChecked = false;
  bool showText =
      false; // Variable pour contrôler l'affichage de l'animation ou du texte

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SignupPage(),
            ));
          },
        ),
        title: Text('RGPD Consent'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            SizedBox(height: 16.0),
            Text(
              'Les données que nous collectons',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8.0),
            Text(
              'Nous collectons les types de données suivants :\n'
              '• Nom et prénom\n'
              '• Adresse email\n'
              '• Numéro de téléphone\n'
              '• Adresse postale\n'
              '• Pseudo\n'
              '• Informations sur vos plantes (photos, descriptions, besoins spécifiques)\n'
              '• Historique des services fournis',
            ),
            SizedBox(height: 16.0),
            Text(
              'Les finalités du traitement',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8.0),
            Text(
              'Nous collectons ces données pour les finalités suivantes :\n'
              '• Pour vous fournir nos services de garde et d\'entretien de plantes\n'
              '• Pour vous contacter concernant vos demandes de services et vos rendez-vous\n'
              '• Pour vous envoyer des newsletters et des informations sur nos services et promotions\n'
              '• Pour améliorer nos services et personnaliser vos conseils d\'entretien des plantes',
            ),
            SizedBox(height: 16.0),
            Text(
              'Les destinataires des données',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8.0),
            Text(
              'Vos données sont susceptibles d\'être transmises aux destinataires suivants :\n'
              '• Nos prestataires de services (botanistes, jardiniers)\n'
              '• Nos partenaires techniques pour l\'hébergement et le traitement des données\n'
              '• Les autorités compétentes si nécessaire, conformément à la loi',
            ),
            SizedBox(height: 16.0),
            Text(
              'Vos droits en matière de protection des données',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8.0),
            Text(
              'En vertu du RGPD, vous disposez des droits suivants :\n'
              '• Droit d\'accès : Vous avez le droit de demander l\'accès à vos données personnelles.\n'
              '• Droit de rectification : Vous pouvez demander la correction de données personnelles inexactes ou incomplètes.\n'
              '• Droit d\'effacement : Vous pouvez demander la suppression de vos données personnelles.\n'
              '• Droit à la limitation du traitement : Vous pouvez demander la limitation du traitement de vos données personnelles.\n'
              '• Droit à la portabilité des données : Vous avez le droit de recevoir vos données personnelles dans un format structuré et couramment utilisé.\n'
              '• Droit d\'opposition : Vous pouvez vous opposer au traitement de vos données personnelles.',
            ),
            SizedBox(height: 16.0),
            Text(
              'En cliquant sur le bouton "J\'accepte", vous consentez à la collecte et à l\'utilisation de vos données personnelles par A’rosaje pour les finalités décrites ci-dessus.\n'
              'Vous pouvez retirer votre consentement à tout moment en contactant [ServiceClient.arosage@gmail.com].',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value ?? false;
                    });
                  },
                ),
               
              ],
            ),
            // Center(
            //   child: ElevatedButton(
            //     onPressed: () {
            //     Navigator.pop(context);
            //     Navigator.of(context).push(MaterialPageRoute(
            //       builder: (context) => const LoginScreen(),
            //     ));
            //   },
            //     child: Text('J\'accepte'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
