import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../../core/design/tokens.dart';
import '../../../core/widgets/rarity.dart' as ds;   // réutilise votre DS
import '../model/capture_result.dart';

class NewVehicleDialog extends StatefulWidget {
  const NewVehicleDialog({
    Key? key,
    required this.result,
    required this.onClose,
    required this.onView,
  }) : super(key: key);

  final CaptureResult result;
  final VoidCallback onClose;
  final VoidCallback onView;

  @override
  State<NewVehicleDialog> createState() => _NewVehicleDialogState();
}

class _NewVehicleDialogState extends State<NewVehicleDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
    _confetti = ConfettiController(duration: const Duration(seconds: 2));
    _ctrl.forward();
    _confetti.play();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    return Stack(
      children: [
        // Fond sombre cliquable
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onClose,
            child: Container(color: Colors.black54),
          ),
        ),
        // Confettis
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confetti,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 24,
            shouldLoop: false,
          ),
        ),
        // Carte animée
        Center(
          child: ScaleTransition(
            scale: _scale,
            child: Container(
              width: 340,
              padding: const EdgeInsets.all(TdxSpace.l),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: TdxRadius.card,
                boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black26)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('New vehicle found!',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  // ✅ badge de rareté du DS
                  ds.RarityChip(rarity: r.rarity),
                  const SizedBox(height: 12),
                  Text(r.vehicleName,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text('+${r.xpGained} XP',
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onClose,
                          child: const Text('Continue'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.onView,
                          child: const Text('View in TurboDex'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
