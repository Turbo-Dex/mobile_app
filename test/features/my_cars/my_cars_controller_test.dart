import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/my_cars/controller/my_cars_controller.dart';
import 'package:mobile_app/features/auth/controller/auth_controller.dart';
import 'package:mobile_app/core/widgets/rarity.dart';
import 'package:mobile_app/features/my_cars/model/body_type.dart';

void main() {
  test('filters apply on loadInitial', () async {
    final container = ProviderContainer(overrides: [
      // on simule un token authentifié
      authControllerProvider.overrideWith((ref) {
        return AuthController(ref)..setTokenForTests('token');
      }),
    ]);
    addTearDown(container.dispose);

    final ctrl = container.read(myCarsControllerProvider.notifier);

    await ctrl.loadInitial();
    final initialLen = container.read(myCarsControllerProvider).items.length;
    expect(initialLen, greaterThan(0));

    await ctrl.setRarity(Rarity.epic);
    final epicLen = container.read(myCarsControllerProvider).items.length;
    expect(epicLen, lessThanOrEqualTo(initialLen));

    await ctrl.setBodyType(BodyType.suv);
    final epicSuvLen = container.read(myCarsControllerProvider).items.length;
    expect(epicSuvLen, lessThanOrEqualTo(epicLen));

    await ctrl.setBrand('Tesla');
    final teslaEpicSuvLen = container.read(myCarsControllerProvider).items.length;
    expect(teslaEpicSuvLen, lessThanOrEqualTo(epicSuvLen));
  });
}

// Petit utilitaire test-only pour le token
extension on AuthController {
  void setTokenForTests(String token) {
    state = state.copyWith(accessToken: token);
  }
}
