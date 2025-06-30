import 'package:equatable/equatable.dart';

import '../../../domain/entity/auth/signin.dart';

class SigninModel extends Equatable {
  final int status;
  final String message;
  final String? token;

  const SigninModel({required this.status, required this.message, this.token});

  factory SigninModel.fromJson(Map<String, dynamic> json) {
    return SigninModel(
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

  Signin toEntity() {
    return Signin(status: status, message: message, token: token ?? '');
  }

  @override
  List<Object?> get props => [status, message, token];
}
