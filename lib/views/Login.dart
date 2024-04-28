import 'package:arosagev1_flutter/animation/FadeAnimation.dart';
import 'package:arosagev1_flutter/views/PlantesFeedPage.dart';
import 'package:arosagev1_flutter/views/inscription.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arosagev1_flutter/bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _pseudoController = TextEditingController();
  final _passwordController = TextEditingController();
  late final LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    // Initialize the LoginBloc
    loginBloc =
        LoginBloc(); // You need to replace LoginBloc with your actual bloc class
  }

  @override
  void dispose() {
    _pseudoController.dispose();
    _passwordController.dispose();
    loginBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: loginBloc,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginFailure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text(state.error),
                    duration: const Duration(seconds: 3),
                  ));
              } else {
                if (state is LoginSuccess) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const PlantesFeed()));
                }
              }
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      gradient:
                          LinearGradient(begin: Alignment.topCenter, colors: [
                    Color(0xFF2C3438),
                    Color.fromARGB(255, 63, 73, 78),
                    Color.fromARGB(255, 44, 54, 45)
                  ])),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 80,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FadeIn(
                                delay: 2,
                                child: Text(
                                  "Connexion",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 40),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            FadeIn(
                                delay: 3,
                                child: Text(
                                  "Bon retour parmis nous",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(60),
                                  topRight: Radius.circular(60))),
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 60,
                                ),
                                FadeIn(
                                    delay: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Color.fromRGBO(
                                                    225, 95, 27, .3),
                                                blurRadius: 20,
                                                offset: Offset(0, 10))
                                          ]),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors
                                                            .grey.shade200))),
                                            child: TextFormField(
                                              controller: _pseudoController,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: const InputDecoration(
                                                  hintText: "Pseudo",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  border: InputBorder.none),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors
                                                            .grey.shade200))),
                                            child: TextFormField(
                                              controller: _passwordController,
                                              textInputAction:
                                                  TextInputAction.done,
                                              obscureText: true,
                                              decoration: const InputDecoration(
                                                  hintText: "Mot de passe",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  border: InputBorder.none),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                const SizedBox(
                                  height: 40,
                                ),
                                FadeIn(
                                    delay: 1,
                                    child: MaterialButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => const SignupPage(),
                                          ));
                                        },
                                        child: const Text(
                                          "Creer un compte",
                                          style: TextStyle(color: Colors.grey),
                                        ))),
                                const SizedBox(
                                  height: 40,
                                ),
                                FadeIn(
                                    delay: 3,
                                    child: MaterialButton(
                                      onPressed: state is! LoginLoading
                                          ? () {
                                              loginBloc.add(
                                                LoginButtonPressed(
                                                  pseudo:
                                                      _pseudoController.text,
                                                  password:
                                                      _passwordController.text,
                                                ),
                                              );
                                            }
                                          : null,
                                      height: 50,
                                      // margin: EdgeInsets.symmetric(horizontal: 50),
                                      color: const Color(0xFF2C3438),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      // decoration: BoxDecoration(
                                      // ),
                                      child: state is LoginLoading
                                          ? const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : const Center(
                                              child: Text(
                                                "Se connecter",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ));
  }
}
