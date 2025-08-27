import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/tokens.dart';
import '../controller/capture_controller.dart';
import '../model/capture_result.dart';
import 'new_vehicle_dialog.dart';

class CapturePage extends ConsumerStatefulWidget {
  const CapturePage({Key? key}) : super(key: key);

  @override
  ConsumerState<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends ConsumerState<CapturePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // On garde l'init caméra ici
    Future.microtask(() => ref.read(captureControllerProvider.notifier).init());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState stateLife) {
    final cam = ref
        .read(captureControllerProvider)
        .camera;
    if (cam == null || !cam.value.isInitialized) return;
    if (stateLife == AppLifecycleState.inactive) {
      cam.dispose();
    } else if (stateLife == AppLifecycleState.resumed) {
      ref.read(captureControllerProvider.notifier).init();
    }
  }

  void _showCelebration(CaptureResult res) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'celebration',
      pageBuilder: (_, __, ___) =>
          NewVehicleDialog(
            result: res,
            onClose: () => Navigator.of(context).pop(),
            onView: () {
              Navigator.of(context).pop();
              if (mounted) context.go('/shell/turbodex');
            },
          ),
      transitionBuilder: (ctx, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 180),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(captureControllerProvider);
    final ctrl = ref.read(captureControllerProvider.notifier);

    ref.listen<CaptureState>(captureControllerProvider, (prev, next) {
      final prevRes = prev?.lastResult;
      final res = next.lastResult;
      if (res != null && res != prevRes && res.newForUser) {
        // diffère l’ouverture du dialog pour ne pas le faire pendant build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _showCelebration(res);
          ref.read(captureControllerProvider.notifier).clearResult();
        });
      }
    });

    if (!state.hasPermission) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(TdxSpace.xl),
          child: Text(state.error ?? 'Camera permission required'),
        ),
      );
    }

    final camera = state.camera;
    if (camera == null || !camera.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        Positioned.fill(child: CameraPreview(camera)),
        SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(state.flashOn ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white),
                onPressed: state.busy ? null : ctrl.toggleFlash,
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 32,
          child: Center(
            child: GestureDetector(
              onTap: state.busy
                  ? null
                  : () async {
                await ctrl.captureAndUpload();
                if (!mounted) return;
                final err = ref
                    .read(captureControllerProvider)
                    .error;
                if (err != null) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Error: $err')));
                }
              },
              child: Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 6),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}