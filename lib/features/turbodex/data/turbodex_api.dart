// lib/features/turbodex/data/turbodex_api.dart
import 'package:dio/dio.dart';
import 'package:mobile_app/features/turbodex/model/dex_entry.dart';
import 'package:mobile_app/features/turbodex/model/dex_sort.dart';

class TurboDexPage {
  final List<DexEntry> items;
  final String? nextCursor;
  final int total;
  final int capturedCount;
  const TurboDexPage({
    required this.items,
    required this.nextCursor,
    required this.total,
    required this.capturedCount,
  });
}

class TurboDexApi {
  final Dio dio;
  TurboDexApi(this.dio);

  Future<TurboDexPage> getDex({
    required String accessToken,
    required DexSort sort,          // <-- paramètre requis
    String? cursor,
  }) async {
    final resp = await dio.get(
      '/turbodex',
      queryParameters: {
        'sort': sort.name,          // "number" | "rarity"
        if (cursor != null) 'cursor': cursor,
      },
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    // TODO: mappe la réponse réelle
    // return TurboDexPage(...);
    throw UnimplementedError('Map the backend response here');
  }
}
