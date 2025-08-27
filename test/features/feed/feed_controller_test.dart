/*
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/feed/controller/feed_controller.dart';
import 'package:mobile_app/features/feed/data/feed_repository.dart';
import 'package:mobile_app/features/feed/model/feed_post.dart';
import 'package:mobile_app/core/widgets/rarity.dart' as ds;
import 'package:mobile_app/features/auth/controller/auth_controller.dart';

class FakeRepo implements IFeedRepository {
  final Map<String, List<FeedPost>> pages;
  FakeRepo(this.pages);

  @override
  Future<(List<FeedPost>, String?)> getFeed({required String accessToken, required scope, String? cursor}) async {
    final key = cursor ?? 'page1';
    final items = pages[key] ?? [];
    final next = key == 'page1' && (pages['page2']?.isNotEmpty ?? false) ? 'page2' : null;
    return (items, next);
  }

  @override
  Future<void> report({required String accessToken, required String postId, required String reason}) async {}

  @override
  Future<void> setLike({required String accessToken, required String postId, required bool like}) async {}
}

ProviderContainer _containerWithAuth(IFeedRepository repo) {
  final c = ProviderContainer(overrides: [
    feedRepoProvider.overrideWithValue(repo),
    authControllerProvider.overrideWith((ref) => AuthController.withToken('token')),
  ]);
  return c;
}

void main() {
  test('pagination merges items', () async {
    final p1 = FeedPost(
      id: '1',
      user: const FeedUser(id: 'u', name: 'A'),
      imageUrl: 'https://x/1.jpg',
      rarity: ds.Rarity.common,
      takenAt: DateTime.now(),
      make: 'Tesla', model: 'S',
    );
    final p2 = FeedPost(
      id: '2',
      user: const FeedUser(id: 'u', name: 'A'),
      imageUrl: 'https://x/2.jpg',
      rarity: ds.Rarity.rare,
      takenAt: DateTime.now(),
      make: 'Ford', model: 'F-150',
    );

    final repo = FakeRepo({'page1': [p1], 'page2': [p2]});
    final container = _containerWithAuth(repo);
    final ctrl = container.read(feedControllerProvider.notifier);

    await ctrl.refresh();
    expect(container.read(feedControllerProvider).items.length, 1);

    await ctrl.nextPage();
    final items = container.read(feedControllerProvider).items;
    expect(items.length, 2);
    expect(items.first.id, '1');
    expect(items.last.id, '2');
  });

  test('toggle like optimistic', () async {
    final p1 = FeedPost(
      id: '1',
      user: const FeedUser(id: 'u', name: 'A'),
      imageUrl: 'https://x/1.jpg',
      rarity: ds.Rarity.common,
      takenAt: DateTime.now(),
      make: 'Tesla', model: 'S',
      likesCount: 0,
      likedByMe: false,
    );

    final repo = FakeRepo({'page1': [p1]});
    final container = _containerWithAuth(repo);
    final ctrl = container.read(feedControllerProvider.notifier);

    await ctrl.refresh();
    ctrl.toggleLike('1');
    final item = container.read(feedControllerProvider).items.first;
    expect(item.likedByMe, true);
    expect(item.likesCount, 1);
  });
}
*/