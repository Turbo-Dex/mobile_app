import 'package:flutter/material.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/rarity.dart';
import '../../core/widgets/badges.dart';
import '../../core/design/tokens.dart';
import '../feed/widgets/vehicle_card.dart';

class DesignPage extends StatelessWidget {
  const DesignPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().subtract(const Duration(hours: 5, minutes: 12));

    return Scaffold(
      appBar: AppBar(title: const Text('Design System')),
      body: ListView(
        padding: const EdgeInsets.all(TdxSpace.l),
        children: [
          const _SectionTitle('Buttons'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              TdxButton.primary(label: 'Primary'),
              TdxButton.secondary(label: 'Secondary'),
              TdxButton.ghost(label: 'Ghost'),
              TdxButton.primary(label: 'With Icon', icon: Icons.camera_alt_outlined),
            ],
          ),

          const SizedBox(height: TdxSpace.xl),
          const _SectionTitle('Rarity chips'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              RarityChip(rarity: Rarity.common),
              RarityChip(rarity: Rarity.rare),
              RarityChip(rarity: Rarity.epic),
              RarityChip(rarity: Rarity.legendary),
            ],
          ),

          const SizedBox(height: TdxSpace.xl),
          const _SectionTitle('Badges'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              ScopeBadge.world(),
              ScopeBadge.friends(),
              TdxBadge(label: '2h ago', icon: Icons.access_time),
              TdxBadge(label: 'Lausanne, CH', icon: Icons.location_on_outlined),
            ],
          ),

          const SizedBox(height: TdxSpace.xl),
          const _SectionTitle('Vehicle card'),
          VehicleCard(
            rarity: Rarity.rare,
            takenAt: now,
            city: 'Lausanne',
            country: 'Switzerland',
            brand: 'Tesla',
            model: 'Model 3',
            likeCount: 12,
            likedByMe: false,
            onLike: () {},
            onShare: () {},
            onReport: () {},
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text, {Key? key}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(text, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
      );
}
