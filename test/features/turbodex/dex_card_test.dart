import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/features/turbodex/view/widgets/dex_card.dart';
import 'package:mobile_app/features/turbodex/model/dex_entry.dart';
import 'package:mobile_app/features/turbodex/model/dex_status.dart';
import 'package:mobile_app/core/widgets/rarity.dart';

Widget wrap(Widget c) => MaterialApp(home: Scaffold(body: Center(child: SizedBox(height: 200, width: 150, child: c))));

void main() {
  testWidgets('Unknown shows ??? and no image', (tester) async {
    final entry = DexEntry(number: 1, rarity: Rarity.common, status: DexStatus.unknown);
    await tester.pumpWidget(wrap(DexCard(entry: entry)));
    expect(find.text('???'), findsOneWidget);
  });

  testWidgets('Seen hides name', (tester) async {
    final entry = DexEntry(number: 2, rarity: Rarity.rare, status: DexStatus.seen, genericImageUrl: 'https://via.placeholder.com/200');
    await tester.pumpWidget(wrap(DexCard(entry: entry)));
    expect(find.textContaining(' '), findsNothing); // pas de "make model"
  });

  testWidgets('Captured shows make/model', (tester) async {
    final entry = DexEntry(number: 3, rarity: Rarity.epic, status: DexStatus.captured, genericImageUrl: 'https://via.placeholder.com/200', make: 'Tesla', model: 'Model S');
    await tester.pumpWidget(wrap(DexCard(entry: entry)));
    expect(find.text('Tesla Model S'), findsOneWidget);
  });
}
