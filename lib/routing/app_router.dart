import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/capture/view/capture_page.dart';
import '../features/feed/view/feed_page.dart';
import '../features/my_cars/view/my_cars_page.dart';
import '../features/profile/view/profile_page.dart';
import '../features/turbodex/view/turbodex_page.dart';

class AppRouter {
  static GoRouter build() {
    return GoRouter(
      initialLocation: '/shell/capture', // Launch on capture tab
      routes: [
        /// TODO : SET login route
        GoRoute(
          path: '/login',
          builder: (context, state) => const _Placeholder('Login'),
        ),

        // Shell with bottom navigation (5 tabs)
        StatefulShellRoute.indexedStack( // Tabs memory stored
          builder: (context, state, navigationShell) {
            return _HomeShell(navigationShell: navigationShell);
          },
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
  const _HomeShell({required this.navigationShell});

  // Persistent state navigation, fluid and no reload
  final StatefulNavigationShell navigationShell;

  // Change tab
  void _goBranch(int index) => navigationShell.goBranch(
    index,
    initialLocation: index == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context) {
    final items = const [
      BottomNavigationBarItem(icon: Icon(Icons.camera_alt_outlined), label: 'Capture'),
      BottomNavigationBarItem(icon: Icon(Icons.dynamic_feed_outlined), label: 'Feed'),
      BottomNavigationBarItem(icon: Icon(Icons.directions_car_outlined), label: 'TurboDex'),
      BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), label: 'My Cars'),
      BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
    ];

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: items
            .map((i) => NavigationDestination(icon: i.icon!, label: i.label!))
            .toList(),
        onDestinationSelected: _goBranch,
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: Text(title)), body: const SizedBox());
}
