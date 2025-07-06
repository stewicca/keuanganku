import 'package:dio/dio.dart';
import 'package:expensetracker/data/models/auth/refresh_model.dart';
import '../../../common/exception.dart';
import '../../models/auth/sign_up_model.dart';
import '../../models/auth/sign_in_model.dart';

abstract class AuthRemoteDataSource {
  Future<SignInModel> login(String username, String password);
  Future<SignUpModel> register(String username, String password);
  Future<RefreshModel> refresh();
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
  Future<RefreshModel> refresh() async {
    try {
      final response = await dio.post('auth/refresh');

      final data = response.data;

      if (response.statusCode == 200) {
        return RefreshModel.fromJson(data);
      } else {
        throw ServerException(data['message'] ?? 'Refresh failed');
      }
    } on DioException catch (error) {
      throw ServerException(error.response?.data['message'] ?? 'Register failed');
    }
  }
}
