import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../model/capture_result.dart';
import '../../../core/widgets/rarity.dart' as ds;

class SasResponse {
  final String sasUrl;
  final String blobName;
  final int maxSize;

  SasResponse({
    required this.sasUrl,
    required this.blobName,
    required this.maxSize,
  });

  factory SasResponse.fromJson(Map<String, dynamic> j) => SasResponse(
    sasUrl: j['sas_url'] as String,
    blobName: j['blob_name'] as String,
    maxSize: (j['max_size'] as num).toInt(),
  );
}

class CaptureApi {
  final Dio _dio;
  CaptureApi(this._dio);

  Future<SasResponse> getSas(
      String accessToken, {
        required String mime,
        required int size,
      }) async {
    final r = await _dio.post(
      '/uploads/sas',
      data: {'mime': mime, 'size': size},
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return SasResponse.fromJson(r.data as Map<String, dynamic>);
  }

  /// Upload direct sur Azure Blob via URL SAS.
  Future<void> putToSas(String sasUrl, Uint8List bytes, {required String mime}) async {
    await _dio.put(
      sasUrl,
      data: Stream.fromIterable(bytes.map((b) => [b])),
      options: Options(
        headers: {
          'x-ms-blob-type': 'BlockBlob',
          'Content-Type': mime,
        },
        followRedirects: false,
        validateStatus: (s) => s != null && s < 400,
      ),
    );
  }

  /// Crée le post côté API et récupère le résultat de capture (nouvelle voiture, rareté, XP...)
  Future<CaptureResult> createPostAndGetResult(
      String accessToken, {
        required String blobName,
        required DateTime takenAt,
        double? lat,
        double? lon,
      }) async {
    final r = await _dio.post(
      '/posts',
      data: {
        'blob_name': blobName,
        'taken_at': takenAt.toUtc().toIso8601String(),
        if (lat != null && lon != null) 'gps': {'lat': lat, 'lon': lon},
      },
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    // Attendu : { ..., "capture_result": { ... } }
    final data = r.data as Map<String, dynamic>;
    final resJson = data['capture_result'] as Map<String, dynamic>?;
    if (resJson == null) {
      // Fallback minimal si backend pas encore prêt.
      return const CaptureResult(
        newForUser: false,
        rarity: ds.Rarity.common,
        vehicleName: 'Unknown vehicle',
        xpGained: 0,
      );
    }
    return CaptureResult.fromJson(resJson);
  }
}
