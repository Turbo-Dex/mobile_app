class Friend {
  final String username;
  final String displayName;
  final String? avatarUrl;
  /// 3 vignettes max (URL d’images; null => placeholder)
  final List<String?> showcase;

  const Friend({
    required this.username,
    required this.displayName,
    this.avatarUrl,
    List<String?>? showcase,
  }) : showcase = showcase ?? const [null, null, null];

  factory Friend.fromJson(Map<String, dynamic> j) => Friend(
    username: j['username'] as String,
    displayName: j['displayName'] as String,
    avatarUrl: j['avatarUrl'] as String?,
    showcase: (j['showcase'] as List?)?.cast<String?>() ??
        const [null, null, null],
  );

  Map<String, dynamic> toJson() => {
    'username': username,
    'displayName': displayName,
    'avatarUrl': avatarUrl,
    'showcase': showcase,
  };

  Friend copyWith({
    String? username,
    String? displayName,
    String? avatarUrl,
    List<String?>? showcase,
  }) =>
      Friend(
        username: username ?? this.username,
        displayName: displayName ?? this.displayName,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        showcase: showcase ?? this.showcase,
      );
}
