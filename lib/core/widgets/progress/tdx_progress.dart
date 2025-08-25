import 'package:flutter/material.dart';
import '../../../app/theme/colors.dart';

class TdxProgressBar extends StatelessWidget {
  const TdxProgressBar({
    Key? key,
    required this.value, // 0..1
    this.height = 10,
    this.backgroundColor = TdxColors.neutral200,
    this.foregroundColor = TdxColors.red,
    this.labelLeft,
    this.labelRight,
  }) : super(key: key);

  final double value;
  final double height;
  final Color backgroundColor;
  final Color foregroundColor;
  final String? labelLeft;
  final String? labelRight;

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (labelLeft != null || labelRight != null) ...[
          Row(
            children: [
              if (labelLeft != null) Text(labelLeft!, style: Theme.of(context).textTheme.labelMedium),
              const Spacer(),
              if (labelRight != null) Text(labelRight!, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: 6),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(height),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(height: height, color: backgroundColor),
                  Container(
                    height: height,
                    width: constraints.maxWidth * v,
                    color: foregroundColor,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Barre d'XP (couleur verte par défaut)
class TdxXpBar extends StatelessWidget {
  const TdxXpBar({
    Key? key,
    required this.current,
    required this.nextLevel,
  }) : super(key: key);

  final int current;
  final int nextLevel;

  @override
  Widget build(BuildContext context) {
    final ratio = nextLevel == 0 ? 0.0 : current / nextLevel;
    return TdxProgressBar(
      value: ratio,
      foregroundColor: TdxColors.success,
      labelLeft: 'XP',
      labelRight: '$current / $nextLevel',
    );
  }
}

/// Barre de progression de collection
class TdxCollectionBar extends StatelessWidget {
  const TdxCollectionBar({
    Key? key,
    required this.captured,
    required this.total,
  }) : super(key: key);

  final int captured;
  final int total;

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : captured / total;
    final pct = (ratio * 100).toStringAsFixed(1);
    return TdxProgressBar(
      value: ratio,
      foregroundColor: TdxColors.red,
      labelLeft: 'Collection',
      labelRight: '$captured / $total  ($pct%)',
    );
  }
}
