// Helper class that give a pre-configured Dio instance for all HTTP request

import 'package:dio/dio.dart';
import '../config/app_env.dart';

class DioClient {
  DioClient._(); // Private constructor

  static Dio build() { // Get configured instance
    final dio = Dio(BaseOptions(
      baseUrl: AppEnv.apiBaseUrl, // API URL
      connectTimeout: const Duration(seconds: 10), // TIMEOUT connection
      receiveTimeout: const Duration(seconds: 20), // TIMEOUT response
    ));

    /// TODO : Add interceptors (auth / logging / retry).
    dio.interceptors.add(LogInterceptor(
      requestBody: false,
      responseBody: false,
      requestHeader: false,
      responseHeader: false,
      error: true,
    ));
    return dio;
  }
}
