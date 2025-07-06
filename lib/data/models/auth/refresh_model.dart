import 'package:equatable/equatable.dart';
import '../../../domain/entity/auth/refresh.dart';

class RefreshModel extends Equatable {
  final int status;
  final String message;
  final String? token;

  const RefreshModel({ required this.status, required this.message, this.token });

  factory RefreshModel.fromJson(Map<String, dynamic> json) {
    return RefreshModel(
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

  Refresh toEntity() {
    return Refresh(status: status, message: message, token: token ?? '');
  }

  @override
  List<Object?> get props => [status, message, token];
}
