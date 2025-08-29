// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/routing/app_router.dart';
import 'theme/theme.dart';

class TurboDexApp extends ConsumerWidget {
  const TurboDexApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'TurboDex',
      debugShowCheckedModeBanner: false,
      theme: TdxTheme.light,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}


