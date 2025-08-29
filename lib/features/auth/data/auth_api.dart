import 'package:dio/dio.dart';
import '../model/auth_models.dart';

class AuthApi {
  final Dio _dio;
  AuthApi(this._dio);

  /// Construit un Dio simple basé sur la variable d'env --dart-define=API_BASE_URL
  static Dio buildDio() {
    final base = const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://localhost:8080',
    );
    return Dio(
      BaseOptions(
        baseUrl: base,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );
  }

  /// Flux historique qui renvoie tokens + user
  Future<LoginResponse> login(LoginRequest req) async {
    final r = await _dio.post('/auth/login', data: req.toJson());

    // Adapte ces clés si ton backend diffère
    final data = r.data as Map<String, dynamic>;
    final tokens = AuthTokens.fromJson(data);

    // Optionnel : récupérer /users/me si non inclus dans /auth/login
    final meResp = await _dio.get(
      '/users/me',
      options: Options(headers: {'Authorization': 'Bearer ${tokens.accessToken}'}),
    );
    final user = UserMe.fromJson(meResp.data as Map<String, dynamic>);

    return LoginResponse(tokens: tokens, user: user);
  }

  /// Méthode de convenance attendue par l'UI/Controller :
  /// renvoie uniquement le token d'accès.
  Future<String> signIn({
    required String username,
    required String password,
  }) async {
    final resp = await login(LoginRequest(username: username, password: password));
    return resp.tokens.accessToken;
  }

  /// Génère/retourne un recovery code pour l'utilisateur courant
  Future<RecoveryCode> generateRecoveryCode(String accessToken) async {
    final r = await _dio.post(
      '/auth/recovery-code',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return RecoveryCode.fromJson(r.data as Map<String, dynamic>);
  }
}
