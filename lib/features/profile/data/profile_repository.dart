import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/friend.dart';
import '../model/user_profile.dart';

/// Contrat: garde ces signatures quand tu brancheras l’API.
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
}

/// Provider du repo
final profileRepositoryProvider = Provider<IProfileRepository>(
      (ref) => DemoProfileRepository(),
);

/// Démo in-memory pour faire tourner l’UI sans backend
class DemoProfileRepository implements IProfileRepository {
  static UserProfile _me = const UserProfile(
    username: 'yourname',
    displayName: 'Your Name',
    avatarUrl: null,
  );

  static final List<Friend> _friends = <Friend>[
    const Friend(username: 'carhunter', displayName: 'Car Hunter'),
    const Friend(username: 'speedster', displayName: 'Speedster'),
  ];

  @override
  Future<UserProfile> me() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _me;
  }

  @override
  Future<List<Friend>> friends() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return List<Friend>.unmodifiable(_friends);
  }

  @override
  Future<void> follow(String username) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (_friends.any((f) => f.username == username)) return;
    _friends.insert(
      0,
      Friend(username: username, displayName: username),
    );
  }

  @override
  Future<void> unfollow(String username) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _friends.removeWhere((f) => f.username == username);
  }

  @override
  Future<UserProfile> updateUsername(String username) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _me = _me.copyWith(
      username: username,
      // si pas de displayName, on cale sur le nouveau handle pour la démo
      displayName: _me.displayName ?? username,
    );
    return _me;
  }

  @override
  Future<UserProfile> updateAvatar(String avatarUrl) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _me = _me.copyWith(avatarUrl: avatarUrl);
    return _me;
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    // Démo: on "accepte" toujours, mais on simule un délai
    await Future<void>.delayed(const Duration(milliseconds: 250));
    // Backend réel: POST /users/me/password { oldPassword, newPassword }
  }
}
