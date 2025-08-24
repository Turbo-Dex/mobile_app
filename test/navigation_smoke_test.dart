import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/app/app.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('App boots on Capture and navigates across 5 tabs',
          (tester) async {
        await tester.pumpWidget(const ProviderScope(child: TurboDexApp()));
        await tester.pumpAndSettle();

        // Tabs labels are present
        expect(find.text('Capture'), findsNWidgets(2));
        expect(find.text('Feed'), findsOneWidget);
        expect(find.text('TurboDex'), findsOneWidget);
        expect(find.text('My Cars'), findsOneWidget);
        expect(find.text('Profile'), findsOneWidget);

        // Start the app on Capture tab
        expect(find.text('Camera coming next'), findsOneWidget);

        // Navigate to Feed
        await tester.tap(find.text('Feed'));
        await tester.pumpAndSettle();
        expect(find.text('World & Friends feed here'), findsOneWidget);

        // Navigate to TurboDex
        await tester.tap(find.text('TurboDex'));
        await tester.pumpAndSettle();
        expect(find.text('Collection stats & list by rarity'), findsOneWidget);

        // Navigate to My Cars
        await tester.tap(find.text('My Cars'));
        await tester.pumpAndSettle();
        expect(find.text('Your captured cars + filters + showcase'), findsOneWidget);

        // Navigate to Profile
        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();
        expect(find.text('User profile, friends, settings'), findsOneWidget);
      });
}
