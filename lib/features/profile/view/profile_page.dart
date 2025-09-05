import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/achievement_card.dart' as tdx;
import '../controller/profile_controller.dart';
import '../../achievements/controller/achievements_controller.dart';
import 'widgets/friend_card.dart';
import '../model/friend.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
              tooltip: 'Settings',
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push('/settings'),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Friends'),
              Tab(text: 'Achievements'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _FriendsTab(),
            const _AchievementsTab(),
          ],
        ),
      ),
    );
  }
}

/// -------- FRIENDS TAB ----------
class _FriendsTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends ConsumerState<_FriendsTab> {
  final _followCtrl = TextEditingController();

  @override
  void dispose() {
    _followCtrl.dispose();
    super.dispose();
  }

  Future<void> _follow() async {
    final v = _followCtrl.text.trim();
    if (v.isEmpty) return;
    await ref.read(profileControllerProvider.notifier).follow(v);
    _followCtrl.clear();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Following @$v')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(profileControllerProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(profileControllerProvider.notifier).refresh(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header user
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: (s.avatarUrl != null ? NetworkImage(s.avatarUrl!) : null)
                as ImageProvider<Object>?,
                child: s.avatarUrl == null
                    ? const Icon(Icons.person_outline, size: 28)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.displayName ?? '@${s.username}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text('@${s.username}',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Follow input
          TextField(
            controller: _followCtrl,
            decoration: const InputDecoration(
              labelText: 'Add / Follow a friend (@username)',
              prefixIcon: Icon(Icons.person_add_alt_1_outlined),
            ),
            onSubmitted: (_) => _follow(),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _follow,
            icon: const Icon(Icons.person_add_alt_1),
            label: const Text('Follow'),
          ),

          const SizedBox(height: 20),

          Text(
            'Friends',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),

          if (s.loading && s.friends.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (s.friends.isEmpty)
            const Text('No friends yet')
          else
            ...s.friends.map(
                  (Friend f) => FriendCard(
                friend: f,
                onUnfollow: () =>
                    ref.read(profileControllerProvider.notifier).unfollow(f.username),
              ),
            ),
        ],
      ),
    );
  }
}

/// -------- ACHIEVEMENTS TAB ----------
class _AchievementsTab extends ConsumerWidget {
  const _AchievementsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ach = ref.watch(achievementsControllerProvider);

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(achievementsControllerProvider.notifier).refresh(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (ach.loading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (ach.items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No achievements yet'),
            )
          else
            ...ach.items.map(
                  (a) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: tdx.AchievementCard(
                  title: a.title,
                  subtitle: a.unlocked
                      ? 'Unlocked • +${a.xp} XP'
                      : '${a.progress}/${a.target} to unlock',
                  progress: a.ratio,
                  icon: _iconFromName(a.icon),
                  claimable: false,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

IconData _iconFromName(String name) {
  switch (name) {
    case 'trophy':
    case 'emoji_events':
      return Icons.emoji_events_outlined;
    case 'car':
    case 'directions_car':
      return Icons.directions_car_outlined;
    case 'bolt':
    case 'flash':
      return Icons.bolt;
    default:
      return Icons.emoji_events_outlined;
  }
}
