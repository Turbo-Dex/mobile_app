import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../auth/controller/auth_controller.dart';
import '../../auth/data/auth_api.dart';
import '../data/capture_api.dart';
import '../data/capture_repository.dart';
import '../model/capture_result.dart';

final captureApiProvider =
Provider((ref) => CaptureApi(AuthApi.buildDio()));

final captureRepoProvider =
Provider<CaptureRepository>((ref) => CaptureRepository(ref.read(captureApiProvider)));

class CaptureState {
  final bool permissionPermanentlyDenied;
  final CameraController? camera;
  final bool hasPermission;
  final bool flashOn;
  final bool busy;
  final String? error;
  final CaptureResult? lastResult;

  const CaptureState({
    this.camera,
    this.hasPermission = false,
    this.flashOn = false,
    this.busy = false,
    this.error,
    this.lastResult,
    this.permissionPermanentlyDenied = false,
  });

  CaptureState copyWith({
    CameraController? camera,
    bool? hasPermission,
    bool? flashOn,
    bool? busy,
    String? error,
    CaptureResult? lastResult,
    bool? permissionPermanentlyDenied,
  }) {
    return CaptureState(
      camera: camera ?? this.camera,
      hasPermission: hasPermission ?? this.hasPermission,
      flashOn: flashOn ?? this.flashOn,
      busy: busy ?? this.busy,
      error: error,
      lastResult: lastResult,
      permissionPermanentlyDenied:
      permissionPermanentlyDenied ?? this.permissionPermanentlyDenied,
    );
  }
}

final captureControllerProvider =
StateNotifierProvider<CaptureController, CaptureState>(
      (ref) => CaptureController(ref),
);

class CaptureController extends StateNotifier<CaptureState> {
  final Ref ref;
  CaptureController(this.ref) : super(const CaptureState());

  // Fallback dev: --dart-define=FAKE_ACCESS_TOKEN=...
  String? _devToken() {
    const t = String.fromEnvironment('FAKE_ACCESS_TOKEN', defaultValue: '');
    return t.isNotEmpty ? t : null;
  }

  Future<void> init() async {
    debugPrint('[capture] init()');

    if (!kIsWeb) {
      final ok = await requestPermissions();
      if (!ok) {
        debugPrint('[capture] permissions denied');
        return;
      }
    } else {
      debugPrint('[capture] web: skip permission_handler, continue');
    }

    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      state = state.copyWith(error: 'No camera found');
      return;
    }
    final back = cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    final controller =
    CameraController(back, ResolutionPreset.medium, enableAudio: false);
    await controller.initialize();
    debugPrint('[capture] camera initialized (${controller.description.name})');

    state =
        state.copyWith(camera: controller, hasPermission: true, error: null);
  }

  Future<bool> requestPermissions() async {
    final cam = await Permission.camera.request();
    final loc = await Permission.location.request();

    final permanentlyDenied =
        cam.isPermanentlyDenied || loc.isPermanentlyDenied;
    final granted = cam.isGranted && loc.isGranted;

    debugPrint('[capture] permissions -> cam=$cam loc=$loc');

    state = state.copyWith(
      hasPermission: granted,
      permissionPermanentlyDenied: permanentlyDenied,
      error: granted ? null : 'Camera or location permission denied',
    );
    return granted;
  }

  Future<void> toggleFlash() async {
    final cam = state.camera;
    if (cam == null) return;

    if (kIsWeb) {
      state = state.copyWith(flashOn: false, error: null);
      debugPrint('[capture] web: torch not supported, ignore');
      return;
    }

    final next = !state.flashOn;
    try {
      await cam.setFlashMode(next ? FlashMode.torch : FlashMode.off);
      state = state.copyWith(flashOn: next, error: null);
    } catch (e) {
      debugPrint('[capture] torch not supported: $e');
      state = state.copyWith(flashOn: false, error: null);
    }
  }

  Future<void> captureAndUpload() async {
    final cam = state.camera;
    final access =
        ref.read(authControllerProvider).accessToken ?? _devToken();

    if (cam == null || access == null) {
      debugPrint('[capture] aborted: no camera or no access token');
      return;
    }

    try {
      state = state.copyWith(busy: true, error: null);

      final xfile = await cam.takePicture();
      final bytes = await xfile.readAsBytes();

      Position? pos;
      try {
        pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
        );
      } catch (_) {
        // pas bloquant
      }

      final captureResult =
      await ref.read(captureRepoProvider).uploadAndCreateWithResult(
        accessToken: access,
        bytes: bytes,
        mime: 'image/jpeg',
        takenAt: DateTime.now(),
        lat: pos?.latitude,
        lon: pos?.longitude,
      );

      debugPrint(
          '[capture] upload+create OK, processedUrl=${captureResult.processedUrl}');
      state = state.copyWith(lastResult: captureResult);
    } catch (e, stErr) {
      debugPrint('[capture] error: $e\n$stErr');
      state = state.copyWith(error: 'Capture failed');
    } finally {
      state = state.copyWith(busy: false);
    }
  }

  void clearResult() => state = state.copyWith(lastResult: null);

  @override
  void dispose() {
    state.camera?.dispose();
    super.dispose();
  }
}
