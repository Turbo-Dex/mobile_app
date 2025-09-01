import 'package:flutter/material.dart';
import 'package:mobile_app/core/design/tokens.dart';
import 'package:mobile_app/core/widgets/rarity.dart';
import 'package:mobile_app/app/theme/colors.dart';
import 'package:mobile_app/features/turbodex/model/dex_entry.dart';
import 'package:mobile_app/features/turbodex/model/dex_status.dart';

class DexCard extends StatelessWidget {
  const DexCard({Key? key, required this.entry}) : super(key: key);
  final DexEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildUnknown() {
      return Container(
        decoration: BoxDecoration(
          color: TdxColors.neutral100,
          borderRadius: TdxRadius.card,
          border: Border.all(color: TdxColors.neutral200),
        ),
        child: Center(
          child: Text(
            '???',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: TdxColors.neutral400,
              letterSpacing: 4,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    Widget buildSeen() {
      final img = entry.genericImageUrl;
      return ClipRRect(
        borderRadius: TdxRadius.card,
        child: Stack(
          children: [
            if (img != null)
              const ColorFiltered(
                colorFilter: ColorFilter.matrix(<double>[
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0, 0, 0, 1, 0,
                ]),
                child: SizedBox.expand(), // placeholder, remplacé juste après
              ),
            if (img != null)
              Positioned.fill(
                child: Image.network(img, fit: BoxFit.cover),
              )
            else
              Positioned.fill(child: Container(color: TdxColors.neutral100)),
            Positioned(top: 8, left: 8, child: RarityChip(rarity: entry.rarity)),
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: TdxRadius.chip,
                ),
                child: Text(
                  '#${entry.number.toString().padLeft(3, '0')}',
                  style: theme.textTheme.labelMedium
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget buildCaptured() {
      final img = entry.genericImageUrl;
      return ClipRRect(
        borderRadius: TdxRadius.card,
        child: Stack(
          children: [
            if (img != null)
              Positioned.fill(
                child: Image.network(img, fit: BoxFit.cover),
              )
            else
              Positioned.fill(child: Container(color: TdxColors.neutral100)),
            Positioned(top: 8, left: 8, child: RarityChip(rarity: entry.rarity)),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (entry.make != null || entry.model != null)
                      Text(
                        '${entry.make ?? ''} ${entry.model ?? ''}'.trim(),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    Text(
                      '#${entry.number.toString().padLeft(3, '0')}',
                      style: theme.textTheme.labelMedium
                          ?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    switch (entry.status) {
      case DexStatus.unknown:
        return buildUnknown();
      case DexStatus.seen:
        return buildSeen();
      case DexStatus.captured:
        return buildCaptured();
    }
  }
}
