import 'package:flutter/material.dart';
import '../../../core/widgets/tdx_scaffold.dart';

class CapturePage extends StatelessWidget {
  const CapturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TdxScaffold(
      title: 'Capture',
      body: Center(child: Text('Camera coming next')),
    );
  }
}
