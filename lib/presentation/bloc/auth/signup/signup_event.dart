part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();
}

class FetchSignup extends SignupEvent {
  final String username;
  final String password;

  const FetchSignup({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}
