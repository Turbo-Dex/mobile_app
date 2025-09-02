// lib/routing/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/capture/view/capture_page.dart';
import '../features/feed/view/feed_page.dart';
import '../features/my_cars/view/my_cars_page.dart';
import '../features/profile/view/profile_page.dart';
import '../features/turbodex/view/turbodex_page.dart';
import '../features/design/design_page.dart';
import '../features/auth/view/login_page.dart';
import '../features/auth/view/recovery_code_page.dart';
import '../features/settings/view/settings_page.dart';
import '../features/auth/controller/auth_controller.dart';

/// Notifie GoRouter quand l’état auth Riverpod change (utile si tu remets un redirect).
class _GoRouterRefresh extends ChangeNotifier {
  _GoRouterRefresh(this.ref) {
    ref.listen(authControllerProvider, (_, __) => notifyListeners());
  }
  final Ref ref;
}

/// Provider exposant la config du routeur.
final appRouterProvider = Provider<GoRouter>((ref) => buildRouter(ref));

/// Fonction top-level (pratique pour les tests).
GoRouter buildRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/shell/capture',
    refreshListenable: _GoRouterRefresh(ref),
    // IMPORTANT : pas de redirection pour laisser les onglets fonctionner.
    redirect: (_, __) => null,

    /*
    // Quand tu voudras réactiver la garde d’auth, remets ceci à la place :
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final loggedIn = auth.accessToken != null;

      final isAuthRoute = state.matchedLocation == '/login'
                       || state.matchedLocation == '/recovery-code';

      if (!loggedIn && !isAuthRoute) return '/login';
      if (loggedIn && isAuthRoute) return '/shell/capture';
      return null;
    },
    */

    routes: [
      // Auth & settings
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/recovery-code', builder: (_, __) => const RecoveryCodePage()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),

      // Page de design (debug)
      GoRoute(path: '/design', builder: (_, __) => const DesignPage()),

      // Shell à 5 onglets
      StatefulShellRoute.indexedStack(
        builder: (_, __, navShell) => _HomeShell(navigationShell: navShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/shell/capture', builder: (_, __) => const CapturePage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/shell/feed', builder: (_, __) => const FeedPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/shell/turbodex', builder: (_, __) => const TurboDexPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/shell/my-cars', builder: (_, __) => const MyCarsPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/shell/profile', builder: (_, __) => const ProfilePage()),
          ]),
        ],
      ),
    ],
  );
}

/// Compat si tu tiens à appeler `AppRouter.build(ref)`
class AppRouter {
  static GoRouter build(Ref ref) => buildRouter(ref);
}

class _HomeShell extends StatelessWidget {
  const _HomeShell({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.camera_alt_outlined), label: 'Capture'),
          NavigationDestination(icon: Icon(Icons.dynamic_feed_outlined), label: 'Feed'),
          NavigationDestination(icon: Icon(Icons.directions_car_outlined), label: 'TurboDex'),
          NavigationDestination(icon: Icon(Icons.grid_view_outlined), label: 'My Cars'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
