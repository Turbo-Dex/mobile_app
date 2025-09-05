import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/friend.dart';
import '../model/user_profile.dart';
import '../model/liked_post.dart';

/// Contrat (garde ces signatures quand tu brancheras l’API).
abstract class IProfileRepository {
  Future<UserProfile> me();
  Future<List<Friend>> friends();

  Future<void> follow(String username);
  Future<void> unfollow(String username);

  /// --- Paramètres de compte (utilisés par SettingsPage) ---
  Future<UserProfile> updateUsername(String username);
  Future<UserProfile> updateAvatar(String avatarUrl);
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });


Future<List<LikedPost>> liked();
}

/// Provider du repo
final profileRepositoryProvider = Provider<IProfileRepository>(
      (ref) => DemoProfileRepository(),
);

/// Démo in-memory pour faire tourner l’UI sans backend
class DemoProfileRepository implements IProfileRepository {
  static const _latency = Duration(milliseconds: 200);

  static UserProfile _me = const UserProfile(
    username: 'yourname',
    displayName: 'Your Name',
    avatarUrl: null,
  );

  static final List<Friend> _friends = <Friend>[
    const Friend(username: 'carhunter', displayName: 'Car Hunter'),
    const Friend(username: 'speedster', displayName: 'Speedster'),
  ];

  // Démo : posts likés (même si l’UI ne les consomme pas aujourd’hui).
  // IMPORTANT : correspond exactement au modèle LikedPost que tu as donné.
  static final List<LikedPost> _liked = <LikedPost>[
    LikedPost(
      id: 'p1',
      vehicle: 'Tesla Model S',
      city: 'Lausanne',
      likedAt: DateTime.now().subtract(const Duration(days: 2)),
      imageUrl: 'https://picsum.photos/seed/tdx1/1200/800',
      postLink: 'https://example.com/posts/1',
    ),
    LikedPost(
      id: 'p2',
      vehicle: 'Porsche 911',
      city: 'Zürich',
      likedAt: DateTime.now().subtract(const Duration(days: 3)),
      imageUrl: 'https://picsum.photos/seed/tdx2/1200/800',
      postLink: 'https://example.com/posts/2',
    ),
  ];

  @override
  Future<UserProfile> me() async {
    await Future<void>.delayed(_latency);
    return _me;
  }

  @override
  Future<List<Friend>> friends() async {
    await Future<void>.delayed(_latency);
    return List<Friend>.unmodifiable(_friends);
  }

  @override
  Future<void> follow(String username) async {
    await Future<void>.delayed(_latency);
    if (_friends.any((f) => f.username == username)) return;
    _friends.insert(
      0,
      Friend(username: username, displayName: username),
    );
  }

  @override
  Future<void> unfollow(String username) async {
    await Future<void>.delayed(_latency);
    _friends.removeWhere((f) => f.username == username);
  }

  @override
  Future<UserProfile> updateUsername(String username) async {
    await Future<void>.delayed(_latency);
    _me = _me.copyWith(
      username: username,
      // si pas de displayName, on cale sur le nouveau handle pour la démo
      displayName: _me.displayName ?? username,
    );
    return _me;
  }

  @override
  Future<UserProfile> updateAvatar(String avatarUrl) async {
    await Future<void>.delayed(_latency);
    _me = _me.copyWith(avatarUrl: avatarUrl);
    return _me;
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    // Démo: on "accepte" toujours, mais on simule un délai
    await Future<void>.delayed(_latency);
    // Backend réel: POST /users/me/password { oldPassword, newPassword }
  }

@override
Future<List<LikedPost>> liked() async {
   await Future<void>.delayed(_latency);
   return List<LikedPost>.unmodifiable(_liked);
  }
}
