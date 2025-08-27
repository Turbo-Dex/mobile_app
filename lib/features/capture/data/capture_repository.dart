import 'dart:typed_data';
import '../model/capture_result.dart';
import 'capture_api.dart';

abstract class ICaptureRepository {
  Future<CaptureResult> uploadAndCreateWithResult({
    required String accessToken,
    required Uint8List bytes,
    required String mime,
    required DateTime takenAt,
    double? lat,
    double? lon,
  });
}

class CaptureRepository implements ICaptureRepository {
  final CaptureApi api;
  CaptureRepository(this.api);

  @override
  Future<CaptureResult> uploadAndCreateWithResult({
    required String accessToken,
    required Uint8List bytes,
    required String mime,
    required DateTime takenAt,
    double? lat,
    double? lon,
  }) async {
    final sas = await api.getSas(accessToken, mime: mime, size: bytes.length);
    if (bytes.length > sas.maxSize) {
      throw Exception('File too large (${bytes.length} > ${sas.maxSize})');
    }
    await api.putToSas(sas.sasUrl, bytes, mime: mime);
    final result = await api.createPostAndGetResult(
      accessToken,
      blobName: sas.blobName,
      takenAt: takenAt,
      lat: lat,
      lon: lon,
    );
    return result;
  }
}
