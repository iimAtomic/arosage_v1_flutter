import 'package:arosagev1_flutter/animation/FadeAnimation.dart';
import 'package:arosagev1_flutter/services/inscription_serv.dart';
import 'package:arosagev1_flutter/views/Login.dart';
import 'package:arosagev1_flutter/views/connexion.dart';
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
  final TextEditingController _pwdCheckController = TextEditingController();
  String dropdownValue = 'P'; // Default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Créer un compte")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            FadeIn(
                delay: 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(32, 29, 26, 0.298),
                            blurRadius: 20,
                            offset: Offset(0, 10))
                      ]),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey.shade200))),
                        child: TextFormField(
                          controller: _nomController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              hintText: "Nom",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey.shade200))),
                        child: TextFormField(
                          controller: _prenomController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              hintText: "Prénom",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey.shade200))),
                        child: TextFormField(
                          controller: _pseudoController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              hintText: "Pseudo",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey.shade200))),
                        child: TextFormField(
                          controller: _pwdController,
                          textInputAction: TextInputAction.next,
                          obscureText: true,
                          decoration: const InputDecoration(
                              hintText: "Mot de passe",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey.shade200))),
                        child: TextFormField(
                          controller: _pwdCheckController,
                          textInputAction: TextInputAction.next,
                          obscureText: true,
                          decoration: const InputDecoration(
                              hintText: "Confirmez votre mot de passe",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey.shade200))),
                        child: TextFormField(
                          controller: _emailController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey.shade200))),
                        child: TextFormField(
                          controller: _rueController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              hintText: "Rue",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey.shade200))),
                        child: TextFormField(
                          controller: _nomVilleController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              hintText: "Nom de la Ville",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey.shade200))),
                        child: TextFormField(
                          controller: _codePostaleController,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                              hintText: "Code Postal",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none),
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        padding: const EdgeInsets.all(10),
                        value: dropdownValue,
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              dropdownValue = value;
                              _codeRoleController.text = value;
                            });
                          }
                        },
                        items: const [
                          DropdownMenuItem(
                              value: 'P', child: Text('Propriétaire')),
                          DropdownMenuItem(value: 'G', child: Text('Gardien')),
                          DropdownMenuItem(
                              value: 'B', child: Text('Botaniste')),
                        ],
                      ),
                    ],
                  ),
                )),
            const SizedBox(
              height: 40,
            ),
            MaterialButton(
              height: 50,
              color: const Color(0xFF2C3438),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              onPressed: () {
                if (_pwdController.text == _pwdCheckController.text) {
                  if (_nomController.text.isNotEmpty &&
                      _prenomController.text.isNotEmpty &&
                      _pseudoController.text.isNotEmpty &&
                      _emailController.text.isNotEmpty &&
                      _rueController.text.isNotEmpty &&
                      _nomVilleController.text.isNotEmpty &&
                      _codePostaleController.text.isNotEmpty &&
                      _pwdController.text.isNotEmpty) {
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
                    ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Inscription réussie!')),
                                );
                                 Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()), // Remplacez AcceuilScreen par l'écran d'accueil de votre app
                  );
                  } else {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(const SnackBar(
                        content: Text("Au moins un champs non rempli"),
                        duration: Duration(seconds: 3),
                      ));
                  }
                } else {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(const SnackBar(
                      content: Text("Les mots de passes ne correspondent pas."),
                      duration: Duration(seconds: 3),
                    ));
                }
              },
              child: const Center(
                child: Text(
                  "S'inscrire",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ));
                },
                child: const Text(
                  "Se connecter",
                  style: TextStyle(color: Colors.grey),
                )),
          ],
        ),
      ),
    );
  }
}
