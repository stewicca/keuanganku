part of 'signin_bloc.dart';

sealed class SigninEvent extends Equatable {
  const SigninEvent();
}

class FetchSignin extends SigninEvent {
  final String username;
  final String password;

  const FetchSignin({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}