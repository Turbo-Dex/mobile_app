import 'package:flutter/material.dart';

// DS components
import '../../core/widgets/inputs/tdx_text_field.dart';
import '../../core/widgets/inputs/tdx_dropdown.dart';
import '../../core/widgets/filters/tdx_filter_chips.dart';
import '../../core/widgets/progress/tdx_progress.dart';
import '../../core/widgets/achievement_card.dart';
import '../../core/widgets/rarity.dart';
import '../../core/icons/tdx_icons.dart';
import '../../core/design/tokens.dart';

class DesignPage extends StatefulWidget {
  const DesignPage({Key? key}) : super(key: key);

  @override
  State<DesignPage> createState() => _DesignPageState();
}

class _DesignPageState extends State<DesignPage> {
  // Inputs demo
  final _usernameCtl = TextEditingController(text: 'alex');
  final _passwordCtl = TextEditingController(text: 'password123');

  // Dropdown demo
  static const _brands = ['Tesla', 'Porsche', 'Toyota', 'Ferrari'];
  String? _brand = _brands.first;

  // Filters demo
  Set<String> _selectedBodies = {'Sedan'};

  @override
  void dispose() {
    _usernameCtl.dispose();
    _passwordCtl.dispose();
    super.dispose();
  }

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
              // Ces trois boutons héritent des thèmes globaux
              // (voir Elevated/Outlined/TextButton theme)
              ElevatedButton(onPressed: null, child: Text('Primary')),
              OutlinedButton(onPressed: null, child: Text('Secondary')),
              TextButton(onPressed: null, child: Text('Ghost')),
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
          const _SectionTitle('Inputs & Dropdown'),
          const SizedBox(height: 8),
          TdxTextField(
            controller: _usernameCtl,
            label: 'Username',
            prefix: const Icon(Icons.person_outline),
          ),
          const SizedBox(height: 12),
          TdxTextField(
            controller: _passwordCtl,
            label: 'Password',
            obscure: true,
          ),
          const SizedBox(height: 12),
          TdxDropdown<String>(
            label: 'Brand',
            items: _brands,
            value: _brand,
            onChanged: (v) => setState(() => _brand = v),
          ),

          const SizedBox(height: TdxSpace.xl),
          const _SectionTitle('Filters'),
          TdxMultiFilter<String>(
            options: const ['Sedan', 'SUV', 'Pickup', 'Coupé'],
            selected: _selectedBodies,
            onChanged: (next) => setState(() => _selectedBodies = next),
            leading: const Icon(TdxIcons.filter),
          ),

          const SizedBox(height: TdxSpace.xl),
          const _SectionTitle('Progress'),
          const SizedBox(height: 8),
          const TdxXpBar(current: 320, nextLevel: 500),
          const SizedBox(height: 12),
          const TdxCollectionBar(captured: 11, total: 151),

          const SizedBox(height: TdxSpace.xl),
          const _SectionTitle('Achievements'),
          const SizedBox(height: 8),
          const AchievementCard(
            title: 'Rookie Spotter',
            subtitle: 'Capture 10 vehicles',
            progress: 0.8,
            claimable: true,
          ),
          const SizedBox(height: 12),
          const AchievementCard(
            title: 'City Hunter',
            subtitle: 'Capture in 5 different cities',
            progress: 0.35,
          ),

          const SizedBox(height: TdxSpace.xl),
          const _SectionTitle('Vehicle card (placeholder)'),
          // simple preview avec les widgets de badges/rarity
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: TdxRadius.card,
              border: Border.all(color: Colors.black12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.black12,
                    alignment: Alignment.center,
                    child: Icon(Icons.directions_car_filled_outlined,
                        size: 64, color: Colors.black.withOpacity(.6)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(TdxSpace.l),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const RarityChip(rarity: Rarity.rare),
                          const Spacer(),
                          Row(
                            children: const [
                              Icon(TdxIcons.time, size: 16),
                              SizedBox(width: 6),
                              Text('5h ago'),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Row(
                            children: const [
                              Icon(TdxIcons.location, size: 16),
                              SizedBox(width: 6),
                              Text('Lausanne, CH'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tesla Model 3',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Captured ${now.toLocal()}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      text,
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(fontWeight: FontWeight.w700),
    ),
  );
}
