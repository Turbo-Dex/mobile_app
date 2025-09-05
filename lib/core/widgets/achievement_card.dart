import 'package:flutter/material.dart';
import '../design/tokens.dart';
import '../../app/theme/colors.dart';
import '../icons/tdx_icons.dart';
import 'progress/tdx_progress.dart';

class AchievementCard extends StatelessWidget {
  const AchievementCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.progress, // 0..1
    this.icon = TdxIcons.trophy,
    this.claimable = false,
    this.onClaim,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final double progress;
  final IconData icon;
  final bool claimable;
  final VoidCallback? onClaim;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TdxSpace.l),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: TdxColors.neutral100,
              child: Icon(icon, color: TdxColors.red),
            ),
            const SizedBox(width: TdxSpace.l),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: theme.textTheme.bodyMedium?.copyWith(color: TdxColors.neutral600)),
                  const SizedBox(height: TdxSpace.m),
                  TdxProgressBar(value: progress, labelRight: '${(progress * 100).round()}%'),
                ],
              ),
            ),
            if (claimable && onClaim != null) ...[
              const SizedBox(width: TdxSpace.m),
              FilledButton(
                onPressed: onClaim,
                style: FilledButton.styleFrom(
                  backgroundColor: TdxColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: const StadiumBorder(),
                ),
                child: const Text('Claim'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
