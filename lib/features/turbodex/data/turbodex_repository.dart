// lib/features/turbodex/data/turbodex_repository.dart
import 'package:mobile_app/features/turbodex/model/dex_entry.dart';
import 'package:mobile_app/features/turbodex/model/dex_sort.dart';
import 'package:mobile_app/features/turbodex/data/turbodex_api.dart';

abstract class ITurboDexRepository {
  Future<(List<DexEntry> items, String? next, int total, int captured)> getDex({
    required String accessToken,
    required DexSort sort,
    String? cursor,
  });
}

class TurboDexRepository implements ITurboDexRepository {
  final TurboDexApi api;
  TurboDexRepository(this.api);

  @override
  Future<(List<DexEntry>, String?, int, int)> getDex({
    required String accessToken,
    required DexSort sort,     // <-- et ici
    String? cursor,
  }) async {
    final page = await api.getDex(
      accessToken: accessToken,
      sort: sort,
      cursor: cursor,
    );
    return (page.items, page.nextCursor, page.total, page.capturedCount);
  }
}
