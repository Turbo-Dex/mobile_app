import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/controller/auth_controller.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    ref.listen(authControllerProvider, (_, next) {
      if (!next.initialized) return;
      if (next.accessToken != null) {
        context.go('/shell/capture');
      } else {
        context.go('/login');
      }
    });
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
