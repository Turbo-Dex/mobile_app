import 'package:dio/dio.dart';
import '../model/feed_post.dart';

enum FeedScope { world, friends }

class FeedPageResponse {
  final List<FeedPost> items;
  final String? nextCursor;
  FeedPageResponse({required this.items, required this.nextCursor});

  factory FeedPageResponse.fromJson(Map<String, dynamic> j) => FeedPageResponse(
    items: (j['items'] as List<dynamic>)
        .map((e) => FeedPost.fromJson(e as Map<String, dynamic>))
        .toList(),
    nextCursor: j['next_cursor'] as String?,
  );
}

class FeedApi {
  final Dio _dio;
  FeedApi(this._dio);

  Future<FeedPageResponse> getFeed({
    required String accessToken,
    required FeedScope scope,
    String? cursor,
    int limit = 20,
  }) async {
    final r = await _dio.get(
      '/feed',
      queryParameters: {
        'scope': scope == FeedScope.world ? 'world' : 'friends',
        'limit': limit,
        if (cursor != null) 'cursor': cursor,
      },
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return FeedPageResponse.fromJson(r.data as Map<String, dynamic>);
  }

  Future<void> like(String accessToken, String postId) async {
    await _dio.post(
      '/posts/$postId/like',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }

  Future<void> unlike(String accessToken, String postId) async {
    await _dio.delete(
      '/posts/$postId/like',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }

  Future<void> report(String accessToken, String postId, {required String reason}) async {
    await _dio.post(
      '/posts/$postId/report',
      data: {'reason': reason},
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }
}
