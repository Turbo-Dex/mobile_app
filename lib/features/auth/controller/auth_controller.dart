import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../model/auth_models.dart';
import 'package:go_router/go_router.dart';
import '../data/auth_api.dart';


/// Providers
final authApiProvider = Provider((ref) => AuthApi(AuthApi.buildDio()));
final authRepoProvider = Provider<IAuthRepository>((ref) => AuthRepository(ref.read(authApiProvider)));

/// Etat Auth minimal
class AuthState {
  final bool loading;
  final UserMe? user;
  final String? accessToken;
  final String? refreshToken;
  final String? error;

  const AuthState({
    this.loading = false,
    this.user,
    this.accessToken,
    this.refreshToken,
    this.error,
  });

  AuthState copyWith({
    bool? loading,
    UserMe? user,
    String? accessToken,
    String? refreshToken,
    String? error,
  }) =>
      AuthState(
        loading: loading ?? this.loading,
        user: user ?? this.user,
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
        error: error,
      );
}

class AuthController extends StateNotifier<AuthState> {
  final IAuthRepository repo;
  AuthController(this.repo) : super(const AuthState());

  Future<void> login({
    required String username,
    required String password,
    required GoRouter router,
  }) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final resp = await repo.login(username, password);
      state = state.copyWith(
        loading: false,
        user: resp.user,
        accessToken: resp.tokens.accessToken,
        refreshToken: resp.tokens.refreshToken,
      );
      router.go('/shell/capture'); // success → capture
    } catch (e) {
      state = state.copyWith(loading: false, error: 'Login failed');
    }
  }
}

final authControllerProvider =
StateNotifierProvider<AuthController, AuthState>((ref) => AuthController(ref.read(authRepoProvider)));
