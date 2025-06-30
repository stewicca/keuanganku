part of 'signup_bloc.dart';

sealed class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final Signup signup;

  SignupSuccess({required this.signup});
}

class SignupError extends SignupState {
  final String message;

  SignupError({required this.message});
}
