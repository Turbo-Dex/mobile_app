import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_api.dart';
import '../model/auth_models.dart';

/// --- State ---
class AuthState {
  final bool busy;
  final String? error;
  final String? accessToken; // token courant si connecté
  final UserMe? me;          // optionnel : /users/me

  const AuthState({
    this.busy = false,
    this.error,
    this.accessToken,
    this.me,
  });

  AuthState copyWith({
    bool? busy,
    String? error,          // passer explicitement null pour clear
    String? accessToken,    // idem
    UserMe? me,             // idem
  }) {
    return AuthState(
      busy: busy ?? this.busy,
      error: error,
      accessToken: accessToken,
      me: me,
    );
  }
}

/// Provider de l'API
final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(AuthApi.buildDio());
});

/// Provider du contrôleur
final authControllerProvider =
StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});

/// --- Controller ---
class AuthController extends StateNotifier<AuthState> {
  AuthController(this._ref) : super(const AuthState());
  final Ref _ref;

  AuthApi get _api => _ref.read(authApiProvider);

  /// Ce que la page de login attend.
  Future<void> signIn(String username, String password) async {
    if (state.busy) return;
    state = state.copyWith(busy: true, error: null);

    try {
      final loginResp = await _api.login(
        LoginRequest(username: username, password: password),
      );
      // on stocke token + user
      state = state.copyWith(
        busy: false,
        error: null,
        accessToken: loginResp.tokens.accessToken,
        me: loginResp.user,
      );
    } catch (e) {
      state = state.copyWith(busy: false, error: 'Login failed');
    }
  }

  Future<RecoveryCode> generateRecoveryCode() async {
    final token = state.accessToken;
    if (token == null) {
      throw StateError('Not authenticated');
    }
    return _api.generateRecoveryCode(token);
  }

  void signOut() {
    state = const AuthState(); // reset
  }
}
