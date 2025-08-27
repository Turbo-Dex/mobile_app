import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/capture/view/capture_page.dart';
import 'package:mobile_app/features/capture/controller/capture_controller.dart';

class FakeCaptureController extends CaptureController {
  FakeCaptureController(Ref ref) : super(ref);
  @override Future<void> init() async {
    // on ne lance pas la vraie caméra en test
    state = state.copyWith(hasPermission: true);
  }
  @override Future<void> captureAndUpload() async {}
}

void main() {
  testWidgets('CapturePage builds', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        captureControllerProvider.overrideWith((ref) => FakeCaptureController(ref)),
      ],
      child: const MaterialApp(home: CapturePage()),
    ));
    await tester.pump();
    // on s’attend au CircularProgressIndicator avant init complet
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
