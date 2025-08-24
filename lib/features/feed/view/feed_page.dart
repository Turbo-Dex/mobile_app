import 'package:flutter/material.dart';
import '../../../core/widgets/tdx_scaffold.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TdxScaffold(
      title: 'Feed',
      body: Center(child: Text('World & Friends feed here')),
    );
  }
}
