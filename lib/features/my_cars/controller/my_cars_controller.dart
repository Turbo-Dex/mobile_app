import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/widgets/rarity.dart';
import 'package:mobile_app/features/my_cars/model/body_type.dart';
import 'package:mobile_app/features/my_cars/model/user_car.dart';
import 'package:mobile_app/features/my_cars/data/my_cars_repository.dart';

class MyCarsState {
  final List<UserCar> items;
  final bool loading;
  final String? error;
  final String? nextCursor;

  final String? brand;
  final Rarity? rarity;
  final BodyType? bodyType;

  final List<String> showcase;

  const MyCarsState({
    this.items = const [],
    this.loading = false,
    this.error,
    this.nextCursor,
    this.brand,
    this.rarity,
    this.bodyType,
    this.showcase = const [],
  });

  MyCarsState copyWith({
    List<UserCar>? items,
    bool? loading,
    String? error,
    String? nextCursor,
    String? brand,
    Rarity? rarity,
    BodyType? bodyType,
    List<String>? showcase,
  }) {
    return MyCarsState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      error: error,
      nextCursor: nextCursor ?? this.nextCursor,
      brand: brand ?? this.brand,
      rarity: rarity ?? this.rarity,
      bodyType: bodyType ?? this.bodyType,
      showcase: showcase ?? this.showcase,
    );
  }
}

final myCarsRepositoryProvider = Provider<IMyCarsRepository>((ref) {
  return MyCarsRepository(ref);
});

final myCarsControllerProvider =
StateNotifierProvider<MyCarsController, MyCarsState>((ref) {
  return MyCarsController(ref);
});

final myCarsBrandsProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.read(myCarsRepositoryProvider);
  return repo.fetchBrands();
});

class MyCarsController extends StateNotifier<MyCarsState> {
  MyCarsController(this.ref) : super(const MyCarsState());
  final Ref ref;

  IMyCarsRepository get _repo => ref.read(myCarsRepositoryProvider);

  Future<void> loadInitial() async {
    try {
      state =
          state.copyWith(loading: true, error: null, items: [], nextCursor: null);

      final showcase = await _repo.getShowcase();

      final res = await _repo.listMyCars(
        brand: state.brand,
        rarity: state.rarity,
        body: state.bodyType,
        cursor: null,
      );

      state = state.copyWith(
        items: res.$1,
        nextCursor: res.$2,
        loading: false,
        error: null,
        showcase: showcase,
      );
    } catch (_) {
      state = state.copyWith(loading: false, error: 'Failed to load your cars');
    }
  }

  Future<void> loadNext() async {
    if (state.loading || state.nextCursor == null) return;
    try {
      state = state.copyWith(loading: true, error: null);
      final res = await _repo.listMyCars(
        brand: state.brand,
        rarity: state.rarity,
        body: state.bodyType,
        cursor: state.nextCursor,
      );
      state = state.copyWith(
        items: [...state.items, ...res.$1],
        nextCursor: res.$2,
        loading: false,
      );
    } catch (_) {
      state = state.copyWith(loading: false, error: 'Failed to load more cars');
    }
  }

  // Filtres
  Future<void> setBrand(String? brand) async {
    state = state.copyWith(brand: brand);
    await loadInitial();
  }

  Future<void> setRarity(Rarity? rarity) async {
    state = state.copyWith(rarity: rarity);
    await loadInitial();
  }

  Future<void> setBodyType(BodyType? body) async {
    state = state.copyWith(bodyType: body);
    await loadInitial();
  }

  // Showcase
  Future<void> addToShowcase(String carId) async {
    final list = [...state.showcase];
    if (list.contains(carId)) return;
    if (list.length >= 3) return;
    list.add(carId);
    state = state.copyWith(showcase: list);
    await _repo.saveShowcase(list);
  }

  Future<void> replaceShowcase({required int index, required String carId}) async {
    final list = [...state.showcase];
    if (index < 0 || index >= list.length) return;
    list[index] = carId;
    state = state.copyWith(showcase: list);
    await _repo.saveShowcase(list);
  }

  Future<void> removeFromShowcase(String carId) async {
    final list = [...state.showcase]..remove(carId);
    state = state.copyWith(showcase: list);
    await _repo.saveShowcase(list);
  }
}
