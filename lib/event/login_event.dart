part of 'package:arosagev1_flutter/bloc/login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String pseudo;
  final String password;

  const LoginButtonPressed({required this.pseudo, required this.password});

  @override
  List<Object> get props => [pseudo, password];

  @override
  String toString() => 'LoginButtonPressed { email: $pseudo, password: $password }';
}