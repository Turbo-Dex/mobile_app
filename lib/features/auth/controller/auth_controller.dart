import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/auth_api.dart';
import '../model/auth_models.dart';
import 'package:dio/dio.dart';

/// --- State ---
class AuthState {
  final bool initialized;       // <-- nouveau : init terminée ?
  final bool busy;
  final String? error;
  final String? accessToken;     // token courant si connecté
  final UserMe? me;              // /v1/auth/me

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
    String? error,          // passer explicitement null pour clear
    String? accessToken,    // idem
    UserMe? me,             // idem
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
final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(AuthApi.buildDio());
});
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// Controller provider
final authControllerProvider =
StateNotifierProvider<AuthController, AuthState>((ref) {
  final c = AuthController(ref);
  // auto-init au boot
  c.init();
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
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // seulement si 401 on purge
        await _storage.delete(key: 'access_token');
        await _storage.delete(key: 'refresh_token');
        state = state.copyWith(initialized: true, accessToken: null, me: null);
      } else {
        // ne pas perdre la session en cas de 404/500 réseau
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
    } catch (_) {
      state = state.copyWith(busy: false, error: 'Login failed');
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
    if (token == null) {
      throw StateError('Not authenticated');
    }
    return _api.generateRecoveryCode(token);
  }

}