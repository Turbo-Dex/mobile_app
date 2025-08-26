import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/app/app.dart';

void main() {
  testWidgets('App boots and shows Login screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TurboDexApp()));
    await tester.pumpAndSettle();

    expect(find.text('Sign in'), findsOneWidget);        // AppBar title in LoginPage
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Generate/Show recovery code'), findsOneWidget);
  });
}
