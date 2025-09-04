import 'dart:typed_data';
import 'package:mobile_app/features/capture/data/capture_api.dart';
import 'package:mobile_app/features/capture/model/capture_result.dart';

class CaptureRepository {
  final CaptureApi api;
  CaptureRepository(this.api);

  Future<CaptureResult> uploadAndCreateWithResult({
    required String accessToken,
    required Uint8List bytes,
    required String mime,
    required DateTime takenAt,
    double? lat,
    double? lon,
  }) async {
    // 1) Upload direct
    final up = await api.uploadMultipart(
      accessToken,
      bytes: bytes,
      filename: 'capture.jpg',
      mime: mime,
    );

    // 2) Créer le post
    final created = await api.createPostRaw(
      accessToken,
      blobName: up.blobName,
      takenAt: takenAt,
      lat: lat,
      lon: lon,
    );

    // 3) Poll et récupérer le JSON complet du post
    final post = await api.waitProcessedFull(accessToken, created.id);

    // 4) Extraire ce qui nous intéresse pour la fiche résultat
    final processedUrl = post?['processed_blob_url'] as String?;
    final ai = (post?['ai'] as Map?)?.cast<String, dynamic>();
    final tags = (post?['tags'] as List?)?.cast<String>();
    final vehicle = (post?['vehicle'] as Map?)?.cast<String, dynamic>();

    return created.result.copyWith(
      processedUrl: processedUrl,
      ai: ai,
      tags: tags,
      vehicleMake: vehicle?['make'] as String?,
      vehicleModel: vehicle?['model'] as String?,
    );
  }
}
