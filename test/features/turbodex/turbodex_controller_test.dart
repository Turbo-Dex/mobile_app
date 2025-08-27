import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/turbodex/controller/turbodex_controller.dart';
import 'package:mobile_app/features/turbodex/data/turbodex_repository.dart';
///import 'package:mobile_app/features/turbodex/data/fake_turbodex_repository.dart';
import 'package:mobile_app/features/auth/controller/auth_controller.dart';
import 'package:mobile_app/core/widgets/rarity.dart' as ds;

/*
// Petit helper pour seed un token
class _AuthTest extends AuthController {
  _AuthTest(Ref ref) : super(ref) {
    state = const AuthState(accessToken: 'token');
  }
}

void main() {
  test('refresh + pagination + completion', () async {
    final repo = FakeTurboDexRepository(total: 60, seed: 11);
    final container = ProviderContainer(overrides: [
      turbodexRepoProvider.overrideWith((ref) => repo),
      authControllerProvider.overrideWith((ref) => _AuthTest(ref)),
    ]);
    final ctrl = container.read(turbodexControllerProvider.notifier);

    await ctrl.refresh();
    final s1 = container.read(turbodexControllerProvider);
    expect(s1.items.isNotEmpty, true);
    expect(s1.total, 60);
    expect(s1.completion >= 0 && s1.completion <= 1, true);

    await ctrl.nextPage();
    final s2 = container.read(turbodexControllerProvider);
    expect(s2.items.length > s1.items.length, true);
  });

  test('filter by rarity', () async {
    final repo = FakeTurboDexRepository(total: 40, seed: 5);
    final container = ProviderContainer(overrides: [
      turbodexRepoProvider.overrideWith((ref) => repo),
      authControllerProvider.overrideWith((ref) => _AuthTest(ref)),
    ]);
    final ctrl = container.read(turbodexControllerProvider.notifier);

    ctrl.setFilter(ds.Rarity.legendary);
    await Future<void>.delayed(const Duration(milliseconds: 10)); // laisse partir la requête
    await ctrl.refresh();
    final s = container.read(turbodexControllerProvider);
    expect(s.items.every((e) => e.rarity == ds.Rarity.legendary), true);
  });
}
*/