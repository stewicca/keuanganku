import 'package:equatable/equatable.dart';
import '../../../domain/entity/auth/sign_up.dart';

class SignUpModel extends Equatable {
  final int status;
  final String message;
  final String? token;


  const SignUpModel({
    required this.status,
    required this.message,
    this.token
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      token: json['data']?['token']
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': {
      'token': token
    }
  };

  SignUp toEntity() => SignUp(
    status: status,
    message: message,
    token: token ?? '',
  );

  @override
  List<Object?> get props => [status, message, token];
}
