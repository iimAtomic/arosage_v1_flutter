
import 'package:arosagev1_flutter/services/auth_serv.dart';
import 'package:arosagev1_flutter/views/PlantesFeedPage.dart';
import 'package:flutter/material.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
        MaterialPageRoute(builder: (context) => const PlantesFeed()),
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
        title: const Text('Connexion'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _pseudoController,
                    decoration: const InputDecoration(labelText: 'Pseudo'),
                  ),
                  TextField(
                    controller: _pwdController,
                    decoration: const InputDecoration(labelText: 'Mot de passe'),
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Se connecter'),
                  ),
                ],
              ),
            ),
    );
  }
}
