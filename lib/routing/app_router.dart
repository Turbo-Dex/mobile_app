import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/capture/view/capture_page.dart';
import '../features/feed/view/feed_page.dart';
import '../features/my_cars/view/my_cars_page.dart';
import '../features/profile/view/profile_page.dart';
import '../features/turbodex/view/turbodex_page.dart';
import '../features/design/design_page.dart';
import '../features/auth/view/login_page.dart';
import '../features/auth/view/recovery_code_page.dart';

class AppRouter {
  static GoRouter build() {
    return GoRouter(
      initialLocation: '/shell/capture', // ✅ login est en dehors du shell
      routes: [
        // Auth routes
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/recovery-code',
          builder: (context, state) => const RecoveryCodePage(),
        ),

        // Design page (debug only)
        GoRoute(
          path: '/design',
          builder: (context, state) => const DesignPage(),
        ),

        // ✅ Bottom nav shell après login
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              _HomeShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/shell/capture',
                  builder: (context, state) => const CapturePage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/shell/feed',
                  builder: (context, state) => const FeedPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/shell/turbodex',
                  builder: (context, state) => const TurboDexPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/shell/my-cars',
                  builder: (context, state) => const MyCarsPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/shell/profile',
                  builder: (context, state) => const ProfilePage(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}


class _HomeShell extends StatelessWidget {
  const _HomeShell({Key? key, required this.navigationShell}) : super(key: key);

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
          NavigationDestination(
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Capture',
          ),
          NavigationDestination(
            icon: Icon(Icons.dynamic_feed_outlined),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_car_outlined),
            label: 'TurboDex',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            label: 'My Cars',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(title)));
  }
}
