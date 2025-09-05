import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tokenStorageProvider = Provider((ref) => const FlutterSecureStorage());

final dioProvider = Provider<Dio>((ref) {
  final baseUrl = const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000', // Android émulateur -> host machine
  );

  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
  ));

  dio.interceptors.add(_AuthInterceptor(ref, dio));
  return dio;
});

class _AuthInterceptor extends Interceptor {
  final Ref ref;
  final Dio dio;
  bool _refreshing = false;

  _AuthInterceptor(this.ref, this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final storage = ref.read(tokenStorageProvider);
    final access = await storage.read(key: 'access_token');
    if (access != null && options.headers['Authorization'] == null) {
      options.headers['Authorization'] = 'Bearer $access';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_refreshing) {
      _refreshing = true;
      try {
        final storage = ref.read(tokenStorageProvider);
        final refresh = await storage.read(key: 'refresh_token');
        if (refresh == null) {
          _refreshing = false;
          return handler.next(err);
        }

        final r = await dio.post('/v1/auth/token/refresh', data: {'refresh_token': refresh});
        final newAccess = (r.data as Map)['access_token'] as String?;
        if (newAccess == null) {
          _refreshing = false;
          return handler.next(err);
        }

        await storage.write(key: 'access_token', value: newAccess);

        final req = err.requestOptions;
        req.headers['Authorization'] = 'Bearer $newAccess';
        final clone = await dio.fetch(req);

        _refreshing = false;
        return handler.resolve(clone);
      } catch (_) {
        _refreshing = false;
        final storage = ref.read(tokenStorageProvider);
        await storage.delete(key: 'access_token');
        await storage.delete(key: 'refresh_token');
        return handler.next(err);
      }
    }
    handler.next(err);
  }
}
