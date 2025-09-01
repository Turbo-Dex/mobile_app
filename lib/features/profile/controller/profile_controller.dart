import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/profile_repository.dart';
import '../model/friend.dart';
import '../model/user_profile.dart';
import '../model/liked_post.dart';

class ProfileState {
  final UserProfile? me;
  final List<Friend> friends;
  final List<LikedPost> liked;      // <- ajouté
  final bool loading;
  final String? error;

  const ProfileState({
    this.me,
    this.friends = const [],
    this.liked = const [],          // <- ajouté
    this.loading = false,
    this.error,
  });

  String get username => me?.username ?? 'anonymous';
  String? get displayName => me?.displayName;
  String? get avatarUrl => me?.avatarUrl;

  ProfileState copyWith({
    UserProfile? me,
    List<Friend>? friends,
    List<LikedPost>? liked,         // <- ajouté
    bool? loading,
    String? error,
  }) =>
      ProfileState(
        me: me ?? this.me,
        friends: friends ?? this.friends,
        liked: liked ?? this.liked,  // <- ajouté
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

  /// pour les tests : alias explicite qui appelle refresh()
  Future<void> init() => refresh();           // <- ajouté

  Future<void> refresh() async {
    try {
      state = state.copyWith(loading: true, error: null);
      final me = await _repo.me();
      final friends = await _repo.friends();
      final liked = await _repo.liked();      // <- ajouté
      state = state.copyWith(
        me: me,
        friends: friends,
        liked: liked,                         // <- ajouté
        loading: false,
      );
    } catch (_) {
      state = state.copyWith(loading: false, error: 'Failed to load profile');
    }
  }

  // ---------- Social ----------
  /// Méthode attendue par les tests
  Future<void> addFriend(String username) async {   // <- ajouté
    final handle = username.startsWith('@') ? username : '@$username';
    await _repo.follow(handle);
    final friends = await _repo.friends();
    state = state.copyWith(friends: friends);
  }

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

  // ---------- Settings ----------
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
    } catch (_) {
      state = state.copyWith(error: 'Failed to update password');
    }
  }
}
