import 'package:arosagev1_flutter/services/inscription_serv.dart';
import 'package:flutter/material.dart';


class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _pseudoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _rueController = TextEditingController();
  final TextEditingController _codeRoleController = TextEditingController();
  final TextEditingController _nomVilleController = TextEditingController();
  final TextEditingController _codePostaleController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Créer un compte")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(controller: _nomController, decoration: InputDecoration(labelText: 'Nom')),
            TextField(controller: _prenomController, decoration: InputDecoration(labelText: 'Prénom')),
            TextField(controller: _pseudoController, decoration: InputDecoration(labelText: 'Pseudo')),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: _rueController, decoration: InputDecoration(labelText: 'Rue')),
            TextField(controller: _codeRoleController, decoration: InputDecoration(labelText: 'Code Role')),
            TextField(controller: _nomVilleController, decoration: InputDecoration(labelText: 'Nom Ville')),
            TextField(controller: _codePostaleController, decoration: InputDecoration(labelText: 'Code Postal')),
            TextField(controller: _pwdController, decoration: InputDecoration(labelText: 'Mot de passe'), obscureText: true),
            ElevatedButton(
              onPressed: () {
                UserController.addUser(
                  _nomController.text,
                  _prenomController.text,
                  _pseudoController.text,
                  _emailController.text,
                  _rueController.text,
                  _codeRoleController.text,
                  _nomVilleController.text,
                  _codePostaleController.text,
                  _pwdController.text,
                );
              },
              child: Text('Créer le compte'),
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
          ],
        ),

      ),

      
    );
  }
}
