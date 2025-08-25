import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';

enum Rarity { common, rare, epic, legendary }

extension RarityX on Rarity {
  String get label {
    switch (this) {
      case Rarity.common: return 'Common';
      case Rarity.rare: return 'Rare';
      case Rarity.epic: return 'Epic';
      case Rarity.legendary: return 'Legendary';
    }
  }

  Color get color {
    switch (this) {
      case Rarity.common: return TdxColors.neutral400;
      case Rarity.rare: return const Color(0xFF2D9CDB);     // blue
      case Rarity.epic: return const Color(0xFF9B51E0);     // purple
      case Rarity.legendary: return const Color(0xFFF1C40F); // gold
    }
  }
}

class RarityChip extends StatelessWidget {
  const RarityChip({Key? key, required this.rarity}) : super(key: key);
  final Rarity rarity;

  @override
  Widget build(BuildContext context) {
    final bg = rarity.color.withOpacity(0.15);
    final fg = rarity.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withOpacity(0.4)),
      ),
      child: Text(
        rarity.label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
