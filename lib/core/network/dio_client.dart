import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/config/app_env.dart'; // si tu as un AppEnv, sinon enlève

/// Provider unique de Dio utilisé par toute l’app.
/// Lis: ref.read(dioProvider)
final dioProvider = Provider<Dio>((ref) {
  final baseUrl = AppEnv.apiBaseUrl; // ou const String.fromEnvironment('API_BASE_URL');
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
    headers: {'Content-Type': 'application/json'},
  ));

  // Intercepteur simple pour bearer si tu as l’auth
  // final auth = ref.read(authControllerProvider);
  // if (auth.accessToken != null) {
  //   dio.options.headers['Authorization'] = 'Bearer ${auth.accessToken}';
  // }

  return dio;
});
