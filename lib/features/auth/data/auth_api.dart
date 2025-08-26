import 'package:dio/dio.dart';
import '../../../app/theme/colors.dart'; // juste pour éviter l'import non utilisé ? supprime si linter
import '../model/auth_models.dart';

class AuthApi {
  final Dio _dio;
  AuthApi(this._dio);

  static Dio buildDio() {
    final base = const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8080');
    final dio = Dio(BaseOptions(baseUrl: base, connectTimeout: const Duration(seconds: 10)));
    return dio;
  }

  Future<LoginResponse> login(LoginRequest req) async {
    final r = await _dio.post('/auth/login', data: req.toJson());
    final data = r.data as Map<String, dynamic>;
    final tokens = AuthTokens.fromJson(data);
    // Optionnel: /users/me si l’API ne renvoie pas le user dans /auth/login
    final meResp = await _dio.get('/users/me', options: Options(headers: {'Authorization': 'Bearer ${tokens.accessToken}'}));
    final user = UserMe.fromJson(meResp.data as Map<String, dynamic>);
    return LoginResponse(tokens: tokens, user: user);
  }

  /// Demande à l’API de générer un recovery code pour l’utilisateur connecté
  Future<RecoveryCode> generateRecoveryCode(String accessToken) async {
    final r = await _dio.post('/auth/recovery-code',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
    return RecoveryCode.fromJson(r.data as Map<String, dynamic>);
  }
}
