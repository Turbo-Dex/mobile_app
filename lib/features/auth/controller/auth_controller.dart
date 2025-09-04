import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart' as dio;

import '../data/auth_api.dart';
import '../model/auth_models.dart';

/// --- State ---
class AuthState {
  final bool initialized;
  final bool busy;
  final String? error;
  final String? accessToken;
  final UserMe? me;

  const AuthState({
    this.initialized = false,
    this.busy = false,
    this.error,
    this.accessToken,
    this.me,
  });

  AuthState copyWith({
    bool? initialized,
    bool? busy,
    String? error,
    String? accessToken,
    UserMe? me,
  }) {
    return AuthState(
      initialized: initialized ?? this.initialized,
      busy: busy ?? this.busy,
      error: error,
      accessToken: accessToken,
      me: me,
    );
  }
}

/// API + SecureStorage providers
final authApiProvider = Provider<AuthApi>((ref) => AuthApi(AuthApi.buildDio()));
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) => const FlutterSecureStorage());

/// Controller provider
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final c = AuthController(ref);
  c.init(); // auto-init au boot
  return c;
});

/// --- Controller ---
class AuthController extends StateNotifier<AuthState> {
  AuthController(this._ref) : super(const AuthState());
  final Ref _ref;

  AuthApi get _api => _ref.read(authApiProvider);
  FlutterSecureStorage get _storage => _ref.read(secureStorageProvider);

  Future<void> init() async {
    if (state.initialized) return;
    try {
      final access = await _storage.read(key: 'access_token');
      final refresh = await _storage.read(key: 'refresh_token');

      if (access == null || refresh == null) {
        state = state.copyWith(initialized: true, accessToken: null, me: null);
        return;
      }

      final me = await _api.meWithToken(access);
      state = state.copyWith(
        initialized: true,
        accessToken: access,
        me: me,
        error: null,
      );
    } on dio.DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _storage.delete(key: 'access_token');
        await _storage.delete(key: 'refresh_token');
        state = state.copyWith(initialized: true, accessToken: null, me: null);
      } else {
        final access = await _storage.read(key: 'access_token');
        state = state.copyWith(initialized: true, accessToken: access, me: null);
      }
    } catch (_) {
      state = state.copyWith(initialized: true, accessToken: null, me: null);
    }
  }

  Future<void> signIn(String username, String password) async {
    if (state.busy) return;
    state = state.copyWith(busy: true, error: null);

    try {
      // 1) login normal
      final resp = await _api.login(LoginRequest(username: username, password: password));
      await _storage.write(key: 'access_token', value: resp.tokens.accessToken);
      await _storage.write(key: 'refresh_token', value: resp.tokens.refreshToken);
      state = state.copyWith(
        busy: false,
        error: null,
        accessToken: resp.tokens.accessToken,
        me: resp.user,
        initialized: true,
      );
      return;

    } on dio.DioException catch (e) {
      final code = e.response?.statusCode;

      // 2) 401: peut être user INEXISTANT -> on propose la création
      if (code == 401) {
        // Si on veut créer le compte, il faut respecter la policy backend (>= 8)
        if (password.length < 8) {
          state = state.copyWith(
            busy: false,
            error: 'New account requires a password with at least 8 characters.',
          );
          return;
        }

        // Tenter le signup puis relancer le login
        try {
          await _api.signup(username: username, password: password, displayName: username);

          final resp = await _api.login(LoginRequest(username: username, password: password));
          await _storage.write(key: 'access_token', value: resp.tokens.accessToken);
          await _storage.write(key: 'refresh_token', value: resp.tokens.refreshToken);
          state = state.copyWith(
            busy: false,
            error: null,
            accessToken: resp.tokens.accessToken,
            me: resp.user,
            initialized: true,
          );
          return;

        } on dio.DioException catch (e2) {
          final code2 = e2.response?.statusCode;
          if (code2 == 409) {
            // username existe déjà → mauvais mot de passe
            state = state.copyWith(busy: false, error: 'Wrong password for @$username');
            return;
          }
          if (code2 == 422) {
            state = state.copyWith(busy: false, error: _extractValidationMsg(e2.response?.data));
            return;
          }
          state = state.copyWith(
            busy: false,
            error: _extractGenericMsg('SIGNUP_HTTP_$code2', e2),
          );
          return;
        }
      }

      // 3) Autres erreurs login
      state = state.copyWith(
        busy: false,
        error: _extractGenericMsg('LOGIN_HTTP_$code', e),
      );
      return;

    } catch (e) {
      state = state.copyWith(busy: false, error: e.toString());
      return;
    }
  }


  Future<void> signOut() async {
    try {
      final refresh = await _storage.read(key: 'refresh_token');
      if (refresh != null) await _api.logout(refresh);
    } finally {
      await _storage.delete(key: 'access_token');
      await _storage.delete(key: 'refresh_token');
      state = const AuthState(initialized: true);
    }
  }

  Future<RecoveryCode> generateRecoveryCode() async {
    final token = state.accessToken;
    if (token == null) throw StateError('Not authenticated');
    return _api.generateRecoveryCode(token);
  }

  // --- Helpers ---

  String _extractGenericMsg(String prefix, dio.DioException e) {
    final body = e.response?.data;
    final msg = body is Map
        ? (body['detail']?.toString() ?? body['message']?.toString() ?? e.message ?? 'error')
        : (body?.toString() ?? e.message ?? 'error');
    return '$prefix $msg';
  }

  String _extractValidationMsg(dynamic data) {
    // Pydantic v2 renvoie { detail: [ { msg, type, loc, ... }, ... ] }
    if (data is Map && data['detail'] is List && (data['detail'] as List).isNotEmpty) {
      final first = (data['detail'] as List).first;
      final msg = first['msg']?.toString();
      final loc = (first['loc'] is List) ? (first['loc'] as List).join('.') : first['loc']?.toString();
      if (msg != null) {
        return loc != null ? '$msg ($loc)' : msg;
      }
    }
    if (data is Map && data['detail'] != null) {
      return data['detail'].toString();
    }
    return 'Validation error';
  }


  Future<void> _persistAndSet(LoginResponse resp) async {
    await _storage.write(key: 'access_token', value: resp.tokens.accessToken);
    await _storage.write(key: 'refresh_token', value: resp.tokens.refreshToken);
    state = state.copyWith(
      busy: false,
      error: null,
      accessToken: resp.tokens.accessToken,
      me: resp.user,
      initialized: true,
    );
  }

  String _extractMsg(dio.DioException e) {
    final body = e.response?.data;
    return body is Map
        ? (body['detail']?.toString() ?? body['message']?.toString() ?? e.message ?? 'error')
        : (body?.toString() ?? e.message ?? 'error');
  }
}
