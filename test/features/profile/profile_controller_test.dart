import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/profile/controller/profile_controller.dart';

void main() {
  test('init loads me, friends and liked', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final ctrl = container.read(profileControllerProvider.notifier);
    await ctrl.init();

    final s = container.read(profileControllerProvider);
    expect(s.me, isNotNull);
    expect(s.friends, isNotEmpty);
    expect(s.liked, isNotEmpty);
  });

  test('add friend increases list length', () async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final ctrl = c.read(profileControllerProvider.notifier);
    await ctrl.init();
    final before = c.read(profileControllerProvider).friends.length;

    await ctrl.addFriend('@newbie');
    final after = c.read(profileControllerProvider).friends.length;

    expect(after, before + 1);
  });

  test('change username updates state', () async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final ctrl = c.read(profileControllerProvider.notifier);
    await ctrl.init();
    await ctrl.changeUsername('@pro');

    expect(c.read(profileControllerProvider).me?.username, '@pro');
  });
}
