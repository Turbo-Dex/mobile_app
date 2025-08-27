import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_app/features/auth/controller/auth_controller.dart';
import 'package:mobile_app/features/auth/data/auth_api.dart';
import 'package:mobile_app/features/turbodex/data/turbodex_api.dart';
import 'package:mobile_app/features/turbodex/data/turbodex_repository.dart';
import 'package:mobile_app/features/turbodex/model/dex_entry.dart';
import 'package:mobile_app/features/turbodex/model/dex_sort.dart';

final turbodexApiProvider = Provider((ref) => TurboDexApi(AuthApi.buildDio()));
final turbodexRepoProvider =
Provider<ITurboDexRepository>((ref) => TurboDexRepository(ref.read(turbodexApiProvider)));

class TurboDexState {
  final List<DexEntry> items;
  final String? nextCursor;
  final bool loading;
  final String? error;
  final int total;
  final int captured;
  final DexSort sort; // <= tri actuel

  double get completion => total == 0 ? 0 : captured / total;

  const TurboDexState({
    this.items = const [],
    this.nextCursor,
    this.loading = false,
    this.error,
    this.total = 0,
    this.captured = 0,
    this.sort = DexSort.number,
  });

  TurboDexState copyWith({
    List<DexEntry>? items,
    String? nextCursor,
    bool? loading,
    String? error,
    int? total,
    int? captured,
    DexSort? sort,
  }) {
    return TurboDexState(
      items: items ?? this.items,
      nextCursor: nextCursor,
      loading: loading ?? this.loading,
      error: error,
      total: total ?? this.total,
      captured: captured ?? this.captured,
      sort: sort ?? this.sort,
    );
  }
}

final turbodexControllerProvider =
StateNotifierProvider<TurboDexController, TurboDexState>((ref) => TurboDexController(ref));

class TurboDexController extends StateNotifier<TurboDexState> {
  final Ref ref;
  TurboDexController(this.ref) : super(const TurboDexState());

  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final token = ref.read(authControllerProvider).accessToken;
      if (token == null) throw Exception('No token');
      final (items, next, total, captured) =
      await ref.read(turbodexRepoProvider).getDex(
        accessToken: token,
        sort: state.sort,
      );
      state = state.copyWith(
        items: items,
        nextCursor: next,
        loading: false,
        total: total,
        captured: captured,
      );
    } catch (_) {
      state = state.copyWith(loading: false, error: 'Failed to load TurboDex');
    }
  }

  Future<void> nextPage() async {
    if (state.loading || state.nextCursor == null) return;
    state = state.copyWith(loading: true);
    try {
      final token = ref.read(authControllerProvider).accessToken;
      if (token == null) throw Exception('No token');
      final (items, next, total, captured) =
      await ref.read(turbodexRepoProvider).getDex(
        accessToken: token,
        sort: state.sort,
        cursor: state.nextCursor,
      );
      state = state.copyWith(
        items: [...state.items, ...items],
        nextCursor: next,
        loading: false,
        total: total,
        captured: captured,
      );
    } catch (_) {
      state = state.copyWith(loading: false);
    }
  }

  void setSort(DexSort s) {
    if (s == state.sort) return;
    state = state.copyWith(sort: s, items: const [], nextCursor: null);
    refresh();
  }
}
