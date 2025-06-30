import 'package:dio/dio.dart';
import '../../../common/exception.dart';
import '../../models/auth/signin_model.dart';
import '../../models/auth/signup_model.dart';

abstract class AuthRemoteDataSource {
  Future<SigninModel> login(String username, String password);
  Future<SignupModel> register(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<SigninModel> login(String username, String password) async {
    try {
      final response = await dio.post(
        "auth/login",
        data: {'username': username, 'password': password},
      );

      final data = response.data;
      if (response.statusCode == 200) {
        return SigninModel.fromJson(data);
      } else {
        throw ServerException(data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Login failed');
    }
  }

  @override
  Future<SignupModel> register(String username, String password) async {
    try {
      final response = await dio.post(
        "auth/register",
        data: {'username': username, 'password': password},
      );

      final data = response.data;
      if (response.statusCode == 201) {
        return SignupModel.fromJson(data);
      } else {
        throw ServerException(data['message'] ?? 'Register failed');
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Register failed');
    }
  }
}
