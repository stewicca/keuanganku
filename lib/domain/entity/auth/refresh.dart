import 'package:equatable/equatable.dart';

class Refresh extends Equatable {
  final int status;
  final String message;
  final String? token;

  const Refresh({
    required this.status,
    required this.message,
    this.token
  });

  @override
  List<Object?> get props => [status, message, token];
}
