import 'package:dio/dio.dart';
import '../model/auth_models.dart';
import 'auth_api.dart';

abstract class IAuthRepository {
  Future<LoginResponse> login(String username, String password);
  Future<RecoveryCode> generateRecoveryCode(String accessToken);
}

class AuthRepository implements IAuthRepository {
  final AuthApi api;
  AuthRepository(this.api);

  @override
  Future<LoginResponse> login(String username, String password) =>
      api.login(LoginRequest(username: username, password: password));

  @override
  Future<RecoveryCode> generateRecoveryCode(String accessToken) =>
      api.generateRecoveryCode(accessToken);
  
}
