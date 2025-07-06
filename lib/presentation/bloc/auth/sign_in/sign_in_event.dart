part of 'sign_in_bloc.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();
}

class FetchSignIn extends SignInEvent {
  final String username;
  final String password;

  const FetchSignIn({ required this.username, required this.password });

  @override
  List<Object> get props => [username, password];
}