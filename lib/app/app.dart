import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routing/app_router.dart';
import 'theme/theme.dart';

class TurboDexApp extends StatelessWidget {
  TurboDexApp({Key? key}) : super(key: key);

  // Router configuré une seule fois
  final GoRouter _router = AppRouter.build();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'TurboDex',
      theme: TurboDexTheme.light(),
      routerConfig: _router,
    );
  }
}
