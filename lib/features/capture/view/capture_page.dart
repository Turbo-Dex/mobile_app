import 'package:flutter/material.dart';
import '../../../core/widgets/tdx_scaffold.dart';
import 'package:go_router/go_router.dart';

class CapturePage extends StatelessWidget {
  const CapturePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TdxScaffold(
      title: 'Capture',
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/design'),
          child: const Text('Open Design System'),
        ),
      ),
    );
  }
}