import 'package:dio/dio.dart';
import '../../../common/exception.dart';
import '../../models/user/user_model.dart';
import '../../models/auth/sign_up_model.dart';
import '../../models/auth/sign_in_model.dart';

abstract class AuthRemoteDataSource {
  Future<SignInModel> login(String username, String password);
  Future<SignUpModel> register(String username, String password);
  Future<UserModel> me();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({ required this.dio });

  @override
  Future<SignInModel> login(String username, String password) async {
    try {
      final response = await dio.post(
        'auth/login',
        data: {
          'username': username,
          'password': password
        }
      );

      final data = response.data;

      if (response.statusCode == 200) {
        return SignInModel.fromJson(data);
      } else {
        throw ServerException(data['message'] ?? 'Login failed');
      }
    } on DioException catch (error) {
      throw ServerException(error.response?.data['message'] ?? 'Login failed');
    }
  }

  @override
  Future<SignUpModel> register(String username, String password) async {
    try {
      final response = await dio.post(
        'auth/register',
        data: {
          'username': username,
          'password': password
        }
      );

      final data = response.data;

      if (response.statusCode == 201) {
        return SignUpModel.fromJson(data);
      } else {
        throw ServerException(data['message'] ?? 'Register failed');
      }
    } on DioException catch (error) {
      throw ServerException(error.response?.data['message'] ?? 'Register failed');
    }
  }

  @override
  Future<UserModel> me() async {
    try {
      final response = await dio.get('auth/me');

      final data = response.data;

      if (response.statusCode == 200) {
        return UserModel.fromJson(data);
      } else {
        throw ServerException(data['message'] ?? 'Get me failed');
      }
    } on DioException catch (error) {
      throw ServerException(error.response?.data['message'] ?? 'Get me failed');
    }
  }
}
