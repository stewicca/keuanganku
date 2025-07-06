part of 'sign_up_bloc.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final SignUp signUp;

  const SignUpSuccess({ required this.signUp });
}

class SignupError extends SignUpState {
  final String message;

  const SignupError({ required this.message });
}
