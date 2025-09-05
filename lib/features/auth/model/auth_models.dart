class LoginRequest {
  final String username;
  final String password;
  const LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() => {'username': username, 'password': password};
}

class AuthTokens {
  final String accessToken;
  final String refreshToken;
  const AuthTokens({required this.accessToken, required this.refreshToken});

  factory AuthTokens.fromJson(Map<String, dynamic> json) => AuthTokens(
    accessToken: json['access_token'] as String,
    refreshToken: json['refresh_token'] as String,
  );
}

class UserMe {
  final String id;
  final String username;
  final String displayName;
  final String? avatarUrl;

  const UserMe({required this.id, required this.username, required this.displayName, this.avatarUrl});

  factory UserMe.fromJson(Map<String, dynamic> j) => UserMe(
    id: j['id'] as String,
    username: j['username'] as String,
    displayName: j['display_name'] as String? ?? j['username'] as String,
    avatarUrl: j['avatar_url'] as String?,
  );
}

class LoginResponse {
  final AuthTokens tokens;
  final UserMe user;
  const LoginResponse({required this.tokens, required this.user});
}

class RecoveryCode {
  final String code; // affiché une seule fois par l’API
  const RecoveryCode(this.code);

  factory RecoveryCode.fromJson(Map<String, dynamic> j) => RecoveryCode(j['recovery_code'] as String);
}
