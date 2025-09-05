import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import '../model/auth_models.dart';

class AuthApi {
  final Dio _dio;
  AuthApi(this._dio);

  /// Construit un Dio basé sur --dart-define=API_BASE_URL.
  /// Fallback auto :
  ///   - Android émulateur : http://10.0.2.2:8000
  ///   - Autres / Web :     http://localhost:8000
  static Dio buildDio() {
    const env = String.fromEnvironment('API_BASE_URL'); // pas de default ici
    final isAndroid = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    final fallback = isAndroid ? 'http://10.0.2.2:8000' : 'http://localhost:8000';
    final base = env.isNotEmpty ? env : fallback;

    final dio = Dio(
      BaseOptions(
        baseUrl: base,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
      ),
    );
    return dio;
  }

  static const _auth = '/v1/auth';

  /// Récupère /v1/auth/me en passant un Bearer explicite
  Future<UserMe> meWithToken(String accessToken) async {
    final r = await _dio.get(
      '$_auth/me',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    final data = r.data as Map<String, dynamic>;
    final m = Map<String, dynamic>.from(data);
    if (m.containsKey('display_name')) m['displayName'] = m.remove('display_name');
    if (m.containsKey('avatar_url')) m['avatarUrl'] = m.remove('avatar_url');
    if (m['id'] != null && m['id'] is! String) m['id'] = m['id'].toString();
    return UserMe.fromJson(m);
  }

  Future<LoginResponse> login(LoginRequest req) async {
    final r = await _dio.post('$_auth/login', data: req.toJson());
    final data = r.data as Map<String, dynamic>;

    final tokens = AuthTokens(
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
    );

    final user = (data['user'] != null)
        ? _parseUser(data['user'])
        : await _fetchMe(tokens.accessToken);

    return LoginResponse(tokens: tokens, user: user);
  }

  Future<void> signup({
    required String username,
    required String password,
    String? displayName,
  }) async {
    await _dio.post('$_auth/signup', data: {
      'username': username,
      'password': password,
      'display_name': displayName ?? username,
    });
  }

  Future<UserMe> _fetchMe(String accessToken) async {
    final meResp = await _dio.get(
      '$_auth/me',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return _parseUser(meResp.data);
  }

  UserMe _parseUser(dynamic raw) {
    final m = Map<String, dynamic>.from(raw as Map);
    if (m.containsKey('display_name')) m['displayName'] = m.remove('display_name');
    if (m.containsKey('avatar_url')) m['avatarUrl'] = m.remove('avatar_url');
    if (m['id'] != null && m['id'] is! String) m['id'] = m['id'].toString();
    return UserMe.fromJson(m);
  }

  /// Méthode utilitaire attendue par certains contrôleurs
  Future<String> signIn({required String username, required String password}) async {
    final resp = await login(LoginRequest(username: username, password: password));
    return resp.tokens.accessToken;
  }

  /// Régénère un recovery code pour l'utilisateur connecté
  Future<RecoveryCode> generateRecoveryCode(String accessToken) async {
    final r = await _dio.post(
      '$_auth/recovery-code',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return RecoveryCode.fromJson(r.data as Map<String, dynamic>);
  }

  /// Refresh -> renvoie un nouvel access token
  Future<String> refreshAccessToken(String refreshToken) async {
    final r = await _dio.post('$_auth/token/refresh', data: {'refresh_token': refreshToken});
    final data = r.data as Map<String, dynamic>;
    return data['access_token'] as String;
  }

  /// Logout (invalide le refresh token côté serveur)
  Future<void> logout(String refreshToken) async {
    await _dio.post('$_auth/logout', data: {'refresh_token': refreshToken});
  }

  /// Reset du mot de passe via recovery code (non authentifié)
  Future<void> resetPassword({
    required String username,
    required String recoveryCode,
    required String newPassword,
  }) async {
    await _dio.post('$_auth/password/reset', data: {
      'username': username,
      'recovery_code': recoveryCode,
      'new_password': newPassword,
    });
  }
}