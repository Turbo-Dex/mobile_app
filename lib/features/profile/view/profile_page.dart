import 'package:flutter/material.dart';
import '../../../core/widgets/tdx_scaffold.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TdxScaffold(
      title: 'Profile',
      body: Center(child: Text('User profile, friends, settings')),
    );
  }
}
