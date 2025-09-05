class UserProfile {
  final String username;
  final String? displayName;
  final String? avatarUrl;

  const UserProfile({
    required this.username,
    this.displayName,
    this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
    username: j['username'] as String,
    displayName: j['displayName'] as String?,
    avatarUrl: j['avatarUrl'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'username': username,
    'displayName': displayName,
    'avatarUrl': avatarUrl,
  };

  UserProfile copyWith({
    String? username,
    String? displayName,
    String? avatarUrl,
  }) =>
      UserProfile(
        username: username ?? this.username,
        displayName: displayName ?? this.displayName,
        avatarUrl: avatarUrl ?? this.avatarUrl,
      );
}
