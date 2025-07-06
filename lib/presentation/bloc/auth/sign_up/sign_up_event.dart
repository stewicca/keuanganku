part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();
}

class FetchSignUp extends SignUpEvent {
  final String username;
  final String password;

  const FetchSignUp({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}
