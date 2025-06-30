import 'package:equatable/equatable.dart';
import '../../../domain/entity/auth/signup.dart';

class SignupModel extends Equatable {
  final int status;
  final String message;
  final String? token;


  const SignupModel({
    required this.status,
    required this.message,
    this.token,
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      token: json['data']?['token'],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': {'token': token},
  };

  Signup toEntity() => Signup(
    status: status,
    message: message,
    token: token ?? '',
  );

  @override
  List<Object?> get props => [status, message, token];
}
