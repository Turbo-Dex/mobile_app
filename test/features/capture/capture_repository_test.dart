import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mobile_app/features/capture/data/capture_repository.dart';
import 'package:mobile_app/features/capture/data/capture_api.dart';
import 'package:mobile_app/features/capture/model/capture_result.dart';
import 'package:mobile_app/core/widgets/rarity.dart' as ds;

class FakeCaptureApi extends CaptureApi {
  FakeCaptureApi() : super(Dio());

  @override
  Future<SasResponse> getSas(String accessToken, {required String mime, required int size}) async {
    return SasResponse(sasUrl: 'https://sas', blobName: 'raw/abc.jpg', maxSize: 9999999);
    // Pour tester la limite, renvoie maxSize = 10 et bytes.length = 20.
  }

  @override
  Future<void> putToSas(String sasUrl, Uint8List bytes, {required String mime}) async {}

  @override
  Future<CaptureResult> createPostAndGetResult(
      String accessToken, {
        required String blobName,
        required DateTime takenAt,
        double? lat,
        double? lon,
      }) async {
    return const CaptureResult(
      newForUser: true,
      rarity: ds.Rarity.epic,
      vehicleName: 'Ferrari 488',
      xpGained: 50,
    );
  }
}

void main() {
  test('CaptureRepository returns result from API', () async {
    final repo = CaptureRepository(FakeCaptureApi());
    final bytes = Uint8List.fromList(List.filled(100, 0xFF));
    final res = await repo.uploadAndCreateWithResult(
      accessToken: 't',
      bytes: bytes,
      mime: 'image/jpeg',
      takenAt: DateTime.now(),
    );
    expect(res.newForUser, isTrue);
    expect(res.rarity, ds.Rarity.epic);
    expect(res.vehicleName, 'Ferrari 488');
    expect(res.xpGained, 50);
  });

  test('CaptureRepository throws when file too large', () async {
    final api = FakeCaptureApi();
    // Override getSas to simulate small maxSize
    Future<SasResponse> smallSas(String _, {required String mime, required int size}) async =>
        SasResponse(sasUrl: 'https://sas', blobName: 'raw/abc.jpg', maxSize: 10);
    // ignore: invalid_use_of_protected_member
    // Hack simple: on crée une classe inline
    final repo = CaptureRepository(_FakeApiSmallSas(apiOverride: smallSas));
    final bytes = Uint8List.fromList(List.filled(20, 0xFF));
    expect(
          () => repo.uploadAndCreateWithResult(
        accessToken: 't',
        bytes: bytes,
        mime: 'image/jpeg',
        takenAt: DateTime.now(),
      ),
      throwsA(isA<Exception>()),
    );
  });
}

class _FakeApiSmallSas extends FakeCaptureApi {
  final Future<SasResponse> Function(String, {required String mime, required int size}) apiOverride;
  _FakeApiSmallSas({required this.apiOverride});

  @override
  Future<SasResponse> getSas(String accessToken, {required String mime, required int size}) {
    return apiOverride(accessToken, mime: mime, size: size);
  }
}
