part of 'signin_bloc.dart';

sealed class SigninState extends Equatable {
  const SigninState();

  @override
  List<Object> get props => [];
}

class SigninInitial extends SigninState {}

class SigninLoading extends SigninState {}

class SigninSuccess extends SigninState {
  final Signin signin;

  SigninSuccess({required this.signin});
}

class SigninError extends SigninState {
  final String message;

  SigninError({required this.message});
}
