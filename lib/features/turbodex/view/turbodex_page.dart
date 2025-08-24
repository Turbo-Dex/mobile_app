import 'package:flutter/material.dart';
import '../../../core/widgets/tdx_scaffold.dart';

class TurboDexPage extends StatelessWidget {
  const TurboDexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TdxScaffold(
      title: 'TurboDex',
      body: Center(child: Text('Collection stats & list by rarity')),
    );
  }
}
