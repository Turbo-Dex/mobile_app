enum AchievementRarity { common, rare, epic, legendary }

class Achievement {
  final String id;
  final String title;
  final String description;
  final AchievementRarity rarity;
  final String icon; // Material Icon name or remote url later
  final int progress; // current
  final int target;   // goal
  final bool unlocked;
  final DateTime? unlockedAt;
  final int xp; // XP granted upon unlock

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.rarity,
    required this.icon,
    required this.progress,
    required this.target,
    required this.unlocked,
    this.unlockedAt,
    required this.xp,
  });

  double get ratio => target == 0 ? 0 : (progress / target).clamp(0, 1);
}
