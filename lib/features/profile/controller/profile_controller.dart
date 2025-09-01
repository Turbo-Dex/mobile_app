import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/profile_repository.dart';
import '../model/friend.dart';
import '../model/user_profile.dart';

class ProfileState {
  final UserProfile? me;
  final List<Friend> friends;
  final bool loading;
  final String? error;

  const ProfileState({
    this.me,
    this.friends = const [],
    this.loading = false,
    this.error,
  });

  String get username => me?.username ?? 'anonymous';
  String? get displayName => me?.displayName;
  String? get avatarUrl => me?.avatarUrl;

  ProfileState copyWith({
    UserProfile? me,
    List<Friend>? friends,
    bool? loading,
    String? error,
  }) =>
      ProfileState(
        me: me ?? this.me,
        friends: friends ?? this.friends,
        loading: loading ?? this.loading,
        error: error,
      );
}

final profileControllerProvider =
StateNotifierProvider<ProfileController, ProfileState>(
      (ref) => ProfileController(ref),
);

class ProfileController extends StateNotifier<ProfileState> {
  ProfileController(this.ref) : super(const ProfileState()) {
    refresh();
  }

  final Ref ref;

  IProfileRepository get _repo => ref.read(profileRepositoryProvider);

  Future<void> refresh() async {
    try {
      state = state.copyWith(loading: true, error: null);
      final me = await _repo.me();
      final friends = await _repo.friends();
      state = state.copyWith(me: me, friends: friends, loading: false);
    } catch (_) {
      state = state.copyWith(loading: false, error: 'Failed to load profile');
    }
  }

  // ---------- Social ----------
  Future<void> follow(String username) async {
    await _repo.follow(username);
    final friends = await _repo.friends();
    state = state.copyWith(friends: friends);
  }

  Future<void> unfollow(String username) async {
    await _repo.unfollow(username);
    final friends = await _repo.friends();
    state = state.copyWith(friends: friends);
  }

  // ---------- Settings (appelées depuis SettingsPage) ----------
  Future<void> changeUsername(String username) async {
    try {
      final updated = await _repo.updateUsername(username);
      state = state.copyWith(me: updated, error: null);
    } catch (_) {
      state = state.copyWith(error: 'Failed to update username');
    }
  }

  Future<void> changeAvatar(String avatarUrl) async {
    try {
      final updated = await _repo.updateAvatar(avatarUrl);
      state = state.copyWith(me: updated, error: null);
    } catch (_) {
      state = state.copyWith(error: 'Failed to update avatar');
    }
  }

  Future<void> changePassword(String oldPwd, String newPwd) async {
    try {
      await _repo.changePassword(oldPassword: oldPwd, newPassword: newPwd);
      // pas de changement d’état spécifique ici; SettingsPage affiche ses SnackBars
    } catch (_) {
      state = state.copyWith(error: 'Failed to update password');
    }
  }
}
