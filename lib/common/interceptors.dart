import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get("token");

    options.headers.addAll({"Authorization": "Bearer $token"});

    print(
      "--> ${options.method != null ? options.method.toUpperCase() : 'METHOD'} ${"" + (options.baseUrl ?? "") + (options.path ?? "")}",
    );
    print("Headers:");
    options.headers.forEach((k, v) => print('$k: $v'));
    if (options.queryParameters != null) {
      print("queryParameters:");
      options.queryParameters.forEach((k, v) => print('$k: $v'));
    }
    if (options.data != null) {
      print("Body: ${options.data}");
    }
    print(
      "--> END ${options.method != null ? options.method.toUpperCase() : 'METHOD'}",
    );
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
      "<-- ${response.statusCode} ${(response.requestOptions != null ? (response.requestOptions.baseUrl + response.requestOptions.path) : 'URL')}",
    );
    print("Headers:");
    response.headers?.forEach((k, v) => print('$k: $v'));
    print("Response: ${response.data}");
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (err.response?.statusCode == 400 || err.response?.statusCode == 403) {
      // navigatorKey.currentState?.pushReplacement(
      //   MaterialPageRoute(builder: (context) => SigninPage()),
      // );
    }

    print(
      "<-- ${err.message} ${(err.requestOptions != null ? (err.requestOptions.baseUrl + err.requestOptions.path) : 'URL')}",
    );
    print(err);
    print("${err.response != null ? err.response?.data : 'Unknown Error'}");
    print("<-- End error");
    return super.onError(err, handler);
  }
}
