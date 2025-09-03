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

class _CapturePageState extends ConsumerState<CapturePage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Lance l'init caméra/permissions au premier affichage
    Future.microtask(
      () => ref.read(captureControllerProvider.notifier).init(),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState stateLife) {
    final cam = ref.read(captureControllerProvider).camera;
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
      pageBuilder: (_, __, ___) => NewVehicleDialog(
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

    // Ouvre la célébration quand un nouveau résultat arrive
    ref.listen<CaptureState>(captureControllerProvider, (prev, next) {
      final prevRes = prev?.lastResult;
      final res = next.lastResult;
      if (res != null && res != prevRes && res.newForUser) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _showCelebration(res);
          ref.read(captureControllerProvider.notifier).clearResult();
        });
      }
    });

    // Permissions non accordées → vue dédiée
    if (!state.hasPermission) {
      return _PermissionView(
        error: state.error,
        permanentlyDenied: state.permissionPermanentlyDenied,
        onRequest: () async {
          final ok = await ctrl.requestPermissions();
          if (ok) await ctrl.init();
        },
      );
    }

    final camera = state.camera;
    if (camera == null || !camera.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final bottomPad = 24.0 + MediaQuery.of(context).padding.bottom;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Aperçu caméra plein écran
        CameraPreview(camera),

        // Toggle flash en haut à droite
        Positioned(
          top: MediaQuery.of(context).padding.top + 12,
          right: 12,
          child: IconButton.filled(
            onPressed: state.busy ? null : ctrl.toggleFlash,
            icon: Icon(state.flashOn ? Icons.flash_on : Icons.flash_off),
          ),
        ),

        // Gros bouton d'obturateur centré au-dessus de la NavigationBar du shell
        Positioned(
          left: 0,
          right: 0,
          bottom: bottomPad,
          child: Center(
            child: FloatingActionButton.large(
              heroTag: 'shutter',
              onPressed: (!state.busy && state.camera != null && state.hasPermission)
                  ? () async {
                      await ctrl.captureAndUpload();
                      if (!mounted) return;
                      final err = ref.read(captureControllerProvider).error;
                      if (err != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $err')),
                        );
                      }
                    }
                  : null, // null => désactivé
              child: state.busy
                  ? const SizedBox(
                      height: 26, width: 26, child: CircularProgressIndicator(strokeWidth: 3))
                  : const Icon(Icons.camera_alt, size: 34),
            ),
          ),
        ),
      ],
    );
  }
}

class _PermissionView extends StatelessWidget {
  const _PermissionView({
    required this.onRequest,
    required this.permanentlyDenied,
    this.error,
  });

  final VoidCallback onRequest;
  final bool permanentlyDenied;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final msg = error ??
        (permanentlyDenied
            ? 'Les permissions Caméra/Localisation sont bloquées.\nOuvre les réglages pour les activer.'
            : 'TurboDex a besoin de la caméra et de la localisation.');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TdxSpace.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.camera_alt_outlined, size: 64),
            const SizedBox(height: 12),
            Text(msg, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onRequest,
              child: Text(permanentlyDenied ? 'Ouvrir les réglages' : 'Autoriser l’accès'),
            ),
          ],
        ),
      ),
    );
  }
}
