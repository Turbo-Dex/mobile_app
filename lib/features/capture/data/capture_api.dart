import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:mobile_app/features/capture/model/capture_result.dart';
import 'package:mobile_app/core/widgets/rarity.dart' as ds;

class CaptureApi {
  final Dio _dio; // Configuré avec baseUrl = API_BASE_URL (…/v1)
  CaptureApi(this._dio);

  // --- 1) Upload direct (multipart) via /v1/images/upload ---
  Future<({String blobName, String? messageId})> uploadMultipart(
      String accessToken, {
        required Uint8List bytes,
        required String filename,
        required String mime,
        String? postId,
      }) async {
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        bytes,
        filename: filename,
        contentType: MediaType.parse(mime),
      ),
      if (postId != null) 'post_id': postId,
    });

    final r = await _dio.post(
      '/images/upload',
      data: form,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    final data = r.data as Map<String, dynamic>;
    return (
    blobName: data['blob_name'] as String,
    messageId: data['message_id'] as String?,
    );
  }

  // --- 2) Créer le post ---
  Future<({String id, CaptureResult result})> createPostRaw(
      String accessToken, {
        required String blobName,
        required DateTime takenAt,
        double? lat,
        double? lon,
      }) async {
    final payload = <String, dynamic>{
      'blob_name': blobName,
      'taken_at': takenAt.toUtc().toIso8601String(),
      if (lat != null && lon != null) 'gps': [lat, lon], // <<< ICI: liste, pas objet
    };

    final r = await _dio.post(
      '/posts',
      data: payload,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    final data = r.data as Map<String, dynamic>;
    final id = data['id'] as String;
    final resJson = data['capture_result'] as Map<String, dynamic>?;

    final result = resJson != null
        ? CaptureResult.fromJson(resJson)
        : const CaptureResult(
      newForUser: false,
      rarity: ds.Rarity.common,
      vehicleName: 'Unknown vehicle',
      xpGained: 0,
    );

    return (id: id, result: result);
  }

  // --- 3) Poll statut jusqu’à processed -> renvoie le JSON complet du post ---
  Future<Map<String, dynamic>?> waitProcessedFull(
      String accessToken,
      String postId, {
        Duration timeout = const Duration(seconds: 30),
        Duration interval = const Duration(seconds: 2),
      }) async {
    final start = DateTime.now();
    while (true) {
      final r = await _dio.get(
        '/posts/$postId',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      final data = r.data as Map<String, dynamic>;
      final status = (data['status'] as String?)?.toLowerCase();
      if (status == 'processed') return data;

      if (DateTime.now().difference(start) > timeout) {
        return data; // peut encore être "pending"
      }
      await Future.delayed(interval);
    }
  }
}
