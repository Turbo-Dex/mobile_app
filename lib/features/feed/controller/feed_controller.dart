import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/data/auth_api.dart';
import '../data/feed_api.dart';
import '../data/feed_repository.dart';
import '../model/feed_post.dart';

final feedApiProvider = Provider((ref) => FeedApi(AuthApi.buildDio()));
final feedRepoProvider = Provider<IFeedRepository>((ref) => FeedRepository(ref.read(feedApiProvider)));

class FeedState {
  final FeedScope scope;
  final List<FeedPost> items;
  final String? nextCursor;
  final bool loading;
  final String? error;

  const FeedState({
    this.scope = FeedScope.world,
    this.items = const [],
    this.nextCursor,
    this.loading = false,
    this.error,
  });

  FeedState copyWith({
    FeedScope? scope,
    List<FeedPost>? items,
    String? nextCursor,
    bool? loading,
    String? error,
  }) {
    return FeedState(
      scope: scope ?? this.scope,
      items: items ?? this.items,
      nextCursor: nextCursor,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

final feedControllerProvider =
StateNotifierProvider<FeedController, FeedState>((ref) => FeedController(ref));

class FeedController extends StateNotifier<FeedState> {
  final Ref ref;
  FeedController(this.ref) : super(const FeedState());

  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final token = ref.read(authControllerProvider).accessToken;
      if (token == null) throw Exception('No token');
      final (items, next) = await ref.read(feedRepoProvider).getFeed(
        accessToken: token,
        scope: state.scope,
      );
      state = state.copyWith(items: items, nextCursor: next, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: 'Failed to load feed');
    }
  }

  Future<void> nextPage() async {
    if (state.loading || state.nextCursor == null) return;
    state = state.copyWith(loading: true);
    try {
      final token = ref.read(authControllerProvider).accessToken;
      if (token == null) throw Exception('No token');
      final (items, next) = await ref.read(feedRepoProvider).getFeed(
        accessToken: token,
        scope: state.scope,
        cursor: state.nextCursor,
      );
      state = state.copyWith(
        items: [...state.items, ...items],
        nextCursor: next,
        loading: false,
      );
    } catch (_) {
      state = state.copyWith(loading: false);
    }
  }

  void setScope(FeedScope scope) {
    if (scope == state.scope) return;
    state = state.copyWith(scope: scope, items: const [], nextCursor: null);
    refresh();
  }

  Future<void> toggleLike(String postId) async {
    final token = ref.read(authControllerProvider).accessToken;
    if (token == null) return;

    // Optimistic update
    final idx = state.items.indexWhere((p) => p.id == postId);
    if (idx == -1) return;
    final p = state.items[idx];
    final newPost = p.copyWith(
      likedByMe: !p.likedByMe,
      likesCount: p.likedByMe ? (p.likesCount - 1) : (p.likesCount + 1),
    );
    final newList = [...state.items]..[idx] = newPost;
    state = state.copyWith(items: newList);

    try {
      await ref.read(feedRepoProvider).setLike(
        accessToken: token,
        postId: postId,
        like: newPost.likedByMe,
      );
    } catch (_) {
      // rollback
      state = state.copyWith(items: [...state.items]..[idx] = p);
    }
  }

  Future<void> report(String postId, {required String reason}) async {
    final token = ref.read(authControllerProvider).accessToken;
    if (token == null) return;
    try {
      await ref.read(feedRepoProvider).report(
        accessToken: token,
        postId: postId,
        reason: reason,
      );
    } catch (_) {}
  }
}
