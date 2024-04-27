import 'package:arosagev1_flutter/views/Login.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  // _navigateToHome() async {
  //   await Future.delayed(Duration(seconds: 3), () {});
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => MessagePage()));
  // }

  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3438),
      body: Center(
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}
