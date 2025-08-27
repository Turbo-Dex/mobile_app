import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/turbodex/model/dex_entry.dart';
import 'package:mobile_app/core/widgets/rarity.dart';
import 'package:mobile_app/features/turbodex/model/dex_status.dart';

int rarityRank(Rarity r) => switch (r) {
  Rarity.common => 0,
  Rarity.rare => 1,
  Rarity.epic => 2,
  Rarity.legendary => 3,
};

void main() {
  test('Sort by rarity asc', () {
    final list = [
      DexEntry(number: 10, rarity: Rarity.legendary, status: DexStatus.seen),
      DexEntry(number: 11, rarity: Rarity.common, status: DexStatus.unknown),
      DexEntry(number: 12, rarity: Rarity.epic, status: DexStatus.captured),
    ];
    list.sort((a, b) => rarityRank(a.rarity).compareTo(rarityRank(b.rarity)));
    expect(list.first.rarity, Rarity.common);
    expect(list.last.rarity, Rarity.legendary);
  });
}
