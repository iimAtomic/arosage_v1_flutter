import 'package:arosagev1_flutter/services/auth_serv.dart';
import 'package:arosagev1_flutter/storage/storage.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'package:arosagev1_flutter/event/login_event.dart';
part 'package:arosagev1_flutter/state/login_state.dart';



class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());

      try {

        var user = await loginAWS(event.pseudo, event.password);
        SecureStorage().writeSecureData("pseudo", user.pseudo);
        SecureStorage().writeSecureData("password", user.password);
        emit(LoginSuccess());
        print("read pseudo : ");
        SecureStorage().readSecureData("pseudo");
        print("read password : ");
        SecureStorage().readSecureData("password");
      } catch (error) {
        emit(LoginFailure(error: error.toString()));
      }
    });
  }
}