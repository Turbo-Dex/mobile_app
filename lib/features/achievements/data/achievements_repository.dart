import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/achievement.dart';

abstract class IAchievementsRepository {
  Future<List<Achievement>> listMyAchievements();
}

final achievementsRepositoryProvider = Provider<IAchievementsRepository>((ref) {
  return _FakeAchievementsRepository();
});

class _FakeAchievementsRepository implements IAchievementsRepository {
  @override
  Future<List<Achievement>> listMyAchievements() async {
    return [
      Achievement(
        id: 'a1',
        title: 'First Capture',
        description: 'Capture your first vehicle',
        rarity: AchievementRarity.common,
        icon: 'emoji_events',
        progress: 1,
        target: 1,
        unlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 10)),
        xp: 50,
      ),
      Achievement(
        id: 'a2',
        title: 'Collector',
        description: 'Capture 25 vehicles',
        rarity: AchievementRarity.rare,
        icon: 'directions_car',
        progress: 14,
        target: 25,
        unlocked: false,
        unlockedAt: null,
        xp: 150,
      ),
      Achievement(
        id: 'a3',
        title: 'Legend Spotter',
        description: 'Capture a Legendary rarity vehicle',
        rarity: AchievementRarity.legendary,
        icon: 'bolt',
        progress: 0,
        target: 1,
        unlocked: false,
        unlockedAt: null,
        xp: 500,
      ),
    ];
  }
}
