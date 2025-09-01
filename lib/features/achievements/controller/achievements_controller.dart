import 'package:flutter_riverpod/flutter_riverpod.dart';

class Achievement {
  final String id;
  final String title;
  final String icon;
  final int progress;
  final int target;
  final int xp;

  const Achievement({
    required this.id,
    required this.title,
    required this.icon,
    required this.progress,
    required this.target,
    required this.xp,
  });

  double get ratio => target == 0 ? 0 : progress / target;
  bool get unlocked => progress >= target;
}

class AchievementsState {
  final bool loading;
  final List<Achievement> items;

  const AchievementsState({this.loading = false, this.items = const []});

  AchievementsState copyWith({
    bool? loading,
    List<Achievement>? items,
  }) =>
      AchievementsState(
        loading: loading ?? this.loading,
        items: items ?? this.items,
      );
}

final achievementsControllerProvider =
StateNotifierProvider<AchievementsController, AchievementsState>((ref) {
  return AchievementsController(const AchievementsState())..refresh();
});

class AchievementsController extends StateNotifier<AchievementsState> {
  AchievementsController(super.state);

  Future<void> refresh() async {
    state = state.copyWith(loading: true);
    await Future<void>.delayed(const Duration(milliseconds: 200));

    state = state.copyWith(
      loading: false,
      items: const [
        Achievement(
          id: 'a1',
          title: 'First capture',
          icon: 'trophy',
          progress: 1,
          target: 1,
          xp: 50,
        ),
        Achievement(
          id: 'a2',
          title: 'Collector',
          icon: 'car',
          progress: 6,
          target: 10,
          xp: 100,
        ),
        Achievement(
          id: 'a3',
          title: 'Lightning',
          icon: 'bolt',
          progress: 2,
          target: 10,
          xp: 100,
        ),
      ],
    );
  }
}
