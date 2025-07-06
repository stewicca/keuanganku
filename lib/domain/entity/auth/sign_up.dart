import 'package:equatable/equatable.dart';

class SignUp extends Equatable {
  final int status;
  final String message;
  final String? token;

  const SignUp({
    required this.status,
    required this.message,
    this.token
  });

  @override
  List<Object?> get props => [status, message, token];
}
