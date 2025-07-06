part of 'sign_in_bloc.dart';

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  final SignIn signIn;

  const SignInSuccess({ required this.signIn });
}

class SignInError extends SignInState {
  final String message;

  const SignInError({ required this.message });
}
