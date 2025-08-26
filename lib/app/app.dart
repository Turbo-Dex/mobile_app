import 'package:flutter/material.dart';
import '../routing/app_router.dart';
import 'theme/theme.dart';

class TurboDexApp extends StatelessWidget {
  const TurboDexApp({Key? key}) : super(key: key);

  static final _router = AppRouter.build();

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
