import 'package:equatable/equatable.dart';

class Signup extends Equatable {
  final int status;
  final String message;
  final String? token;

  Signup({
    required this.status,
    required this.message,
    this.token,
  });

  @override
  List<Object?> get props => [status, message, token];
}
