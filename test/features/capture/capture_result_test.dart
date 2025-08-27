import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/capture/model/capture_result.dart';
import 'package:mobile_app/core/widgets/rarity.dart' as ds;

void main() {
  test('CaptureResult maps rarity strings to DS enum', () {
    final r1 = CaptureResult.fromJson({
      'new_for_user': true,
      'rarity': 'rare',
      'vehicle_name': 'Test',
      'xp_gained': 10,
    });
    expect(r1.rarity, ds.Rarity.rare);

    final r2 = CaptureResult.fromJson({'rarity': 'Epic'});
    expect(r2.rarity, ds.Rarity.epic);

    final r3 = CaptureResult.fromJson({'rarity': 'LEGENDARY'});
    expect(r3.rarity, ds.Rarity.legendary);

    final r4 = CaptureResult.fromJson({'rarity': 'unknown'});
    expect(r4.rarity, ds.Rarity.common);
  });

  test('CaptureResult maps numeric rarity to DS enum', () {
    expect(CaptureResult.fromJson({'rarity': 0}).rarity, ds.Rarity.common);
    expect(CaptureResult.fromJson({'rarity': 1}).rarity, ds.Rarity.rare);
    expect(CaptureResult.fromJson({'rarity': 2}).rarity, ds.Rarity.epic);
    expect(CaptureResult.fromJson({'rarity': 3}).rarity, ds.Rarity.legendary);
  });
}
