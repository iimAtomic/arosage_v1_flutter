
import 'package:arosagev1_flutter/services/auth_serv.dart';
import 'package:arosagev1_flutter/views/MessagePage.dart';
import 'package:arosagev1_flutter/views/PlantesFeedPage.dart';
import 'package:flutter/material.dart';

import 'custom_drawer.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _pseudoController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  bool _isLoading = false;

  void _submit() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = await login(_pseudoController.text, _pwdController.text);
      // Connectez l'utilisateur et naviguez vers la page d'accueil.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PlantesFeed()),
      );
    } catch (e) {
      // Affichez une erreur si la connexion échoue.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la connexion: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _pseudoController,
                    decoration: InputDecoration(labelText: 'Pseudo'),
                  ),
                  TextField(
                    controller: _pwdController,
                    decoration: InputDecoration(labelText: 'Mot de passe'),
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text('Se connecter'),
                  ),
                ],
              ),
            ),
    );
  }
}
