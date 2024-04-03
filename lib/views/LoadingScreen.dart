import 'package:arosagev1_flutter/views/MessagePage.dart';
import 'package:arosagev1_flutter/views/connexion.dart';
import 'package:flutter/material.dart';
import 'inscription.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MessagePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C3438),
      body: Center(
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}
