import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'navigation.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final message = err.response?.data['message'];

    if (status == 401 && message == 'Full authentication is required to access this resource' && !err.requestOptions.path.contains('auth/refresh')) {
      final prefs = await SharedPreferences.getInstance();

      try {
        final response = await dio.post('auth/refresh');

        if (response.statusCode == 200) {
          final newToken = response.data['data']?['token'];

          if (newToken != null) {
            await prefs.setString('token', newToken);

            err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

            final clonedResponse = await dio.fetch(err.requestOptions);

            return handler.resolve(clonedResponse);
          }
        }
      } on DioException catch (refreshErr) {
        final refreshStatus = refreshErr.response?.statusCode;
        final refreshMessage = refreshErr.response?.data['message'];

        if (refreshStatus == 400 && refreshMessage == 'Token expired') {
          await prefs.remove('token');

          navigatorKey.currentState?.pushNamedAndRemoveUntil('/', (route) => false);
        }

        return handler.reject(refreshErr);
      }
    }

    return super.onError(err, handler);
  }
}
