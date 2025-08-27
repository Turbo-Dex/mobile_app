import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

import '../../auth/controller/auth_controller.dart';
import '../data/capture_repository.dart';
import '../data/capture_api.dart';
import 'package:dio/dio.dart';
import '../../auth/data/auth_api.dart';
import '../model/capture_result.dart';

final captureApiProvider = Provider((ref) => CaptureApi(AuthApi.buildDio()));
final captureRepoProvider = Provider<ICaptureRepository>((ref) => CaptureRepository(ref.read(captureApiProvider)));

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
  }) => CaptureState(
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

final captureControllerProvider = StateNotifierProvider<CaptureController, CaptureState>(
      (ref) => CaptureController(ref),
);

class CaptureController extends StateNotifier<CaptureState> {
  final Ref ref;

  CaptureController(this.ref) : super(const CaptureState());

  Future<void> init() async {
    if (!state.hasPermission) {
      final ok = await requestPermissions();
      if (!ok) return;
    }


    final cameras = await availableCameras();
    final back = cameras.firstWhere((c) =>
    c.lensDirection == CameraLensDirection.back, orElse: () => cameras.first);
    final controller = CameraController(
        back, ResolutionPreset.medium, enableAudio: false);
    await controller.initialize();
    state =
        state.copyWith(camera: controller, hasPermission: true, error: null);
  }

  Future<bool> requestPermissions() async {
    final cam = await Permission.camera.request();
    final loc = await Permission.location.request();

    final permanentlyDenied =
        cam.isPermanentlyDenied || loc.isPermanentlyDenied;

    final granted = cam.isGranted && loc.isGranted;

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
    final next = !state.flashOn;
    await cam.setFlashMode(next ? FlashMode.torch : FlashMode.off);
    state = state.copyWith(flashOn: next);
  }

  Future<void> captureAndUpload() async {
    final cam = state.camera;
    final access = ref
        .read(authControllerProvider)
        .accessToken;
    if (cam == null || access == null) return;

    try {
      state = state.copyWith(busy: true, error: null);
      final xfile = await cam.takePicture();
      final bytes = await xfile.readAsBytes();

      Position? pos;
      try {
        pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
        );
      } catch (_) {}

      final result = await ref
          .read(captureRepoProvider)
          .uploadAndCreateWithResult(
        accessToken: access,
        bytes: bytes,
        mime: 'image/jpeg',
        takenAt: DateTime.now(),
        lat: pos?.latitude,
        lon: pos?.longitude,
      );

      state = state.copyWith(lastResult: result);
    } catch (e) {
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
