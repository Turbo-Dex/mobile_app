import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design/tokens.dart';
import '../controller/capture_controller.dart';
import '../model/capture_result.dart';
import 'new_vehicle_dialog.dart';

class CapturePage extends ConsumerWidget {
  const CapturePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(captureControllerProvider);
    final ctrl = ref.read(captureControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Capture')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (st.camera == null)
                ElevatedButton(
                  onPressed: () => ctrl.init(),
                  child: const Text('Init camera'),
                )
              else
                const Text('Camera ready'),

              const SizedBox(height: 24),

              // ---- Résultat IA (si dispo)
              if (st.lastResult != null) ...[
                const Divider(),
                Text(
                  'Résultat',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (st.lastResult!.processedUrl != null)
                  Image.network(
                    st.lastResult!.processedUrl!,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 8),
                Text('Rareté : ${st.lastResult!.rarity.name}'),
                Text('Véhicule : ${st.lastResult!.vehicleMake ?? "-"} ${st.lastResult!.vehicleModel ?? ""}'),
                Text('XP : ${st.lastResult!.xpGained}'),
                if (st.lastResult!.tags != null && st.lastResult!.tags!.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: st.lastResult!.tags!
                        .take(8)
                        .map((t) => Chip(label: Text(t)))
                        .toList(),
                  ),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: st.busy ? null : () async {
          try {
            await ctrl.captureAndUpload();
            final r = st.lastResult;
            final messenger = ScaffoldMessenger.maybeOf(context);
            messenger?.showSnackBar(
              SnackBar(
                content: Text(
                  r?.processedUrl != null
                      ? '✅ Traitée !'
                      : '📤 Envoyée, traitement en cours…',
                ),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
              SnackBar(content: Text('Erreur capture: $e')),
            );
          }
        },
        label: Text(st.busy ? '…' : 'Capture'),
        icon: const Icon(Icons.camera_alt),
      ),
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
