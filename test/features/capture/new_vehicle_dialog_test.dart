import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/capture/view/new_vehicle_dialog.dart';
import 'package:mobile_app/features/capture/model/capture_result.dart';
import 'package:mobile_app/core/widgets/rarity.dart' as ds;

void main() {
  testWidgets('NewVehicleDialog shows info & actions', (tester) async {
    const res = CaptureResult(
      newForUser: true,
      rarity: ds.Rarity.rare,
      vehicleName: 'Porsche 911',
      xpGained: 30,
    );

    await tester.pumpWidget(MaterialApp(
      home: NewVehicleDialog(
        result: res,
        onClose: () {},
        onView: () {},
      ),
    ));

    expect(find.text('New vehicle found!'), findsOneWidget);
    expect(find.text('Porsche 911'), findsOneWidget);
    expect(find.textContaining('XP'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('View in TurboDex'), findsOneWidget);
  });
}
