import '../model/feed_post.dart';
import 'feed_api.dart';

abstract class IFeedRepository {
  Future<(List<FeedPost> items, String? next)> getFeed({
    required String accessToken,
    required FeedScope scope,
    String? cursor,
  });

  Future<void> setLike({required String accessToken, required String postId, required bool like});
  Future<void> report({required String accessToken, required String postId, required String reason});
}

class FeedRepository implements IFeedRepository {
  final FeedApi api;
  FeedRepository(this.api);

  @override
  Future<(List<FeedPost>, String?)> getFeed({
    required String accessToken,
    required FeedScope scope,
    String? cursor,
  }) async {
    final res = await api.getFeed(accessToken: accessToken, scope: scope, cursor: cursor);
    return (res.items, res.nextCursor);
  }

  @override
  Future<void> setLike({required String accessToken, required String postId, required bool like}) {
    return like ? api.like(accessToken, postId) : api.unlike(accessToken, postId);
  }

  @override
  Future<void> report({required String accessToken, required String postId, required String reason}) {
    return api.report(accessToken, postId, reason: reason);
  }
}
