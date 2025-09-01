import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_app/app/theme/colors.dart';
import 'package:mobile_app/core/design/tokens.dart';
import 'package:mobile_app/core/widgets/filters/tdx_filter_bar.dart';
import 'package:mobile_app/core/widgets/inputs/tdx_dropdown.dart';
import 'package:mobile_app/core/widgets/rarity.dart';

import 'package:mobile_app/features/my_cars/model/body_type.dart';
import 'package:mobile_app/features/my_cars/controller/my_cars_controller.dart';
import 'package:mobile_app/features/my_cars/view/widgets/my_car_card.dart';

class MyCarsPage extends ConsumerStatefulWidget {
  const MyCarsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyCarsPage> createState() => _MyCarsPageState();
}

class _MyCarsPageState extends ConsumerState<MyCarsPage> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(myCarsControllerProvider.notifier).loadInitial());
    _scroll.addListener(() {
      final max = _scroll.position.maxScrollExtent;
      if (_scroll.position.pixels > max - 600) {
        ref.read(myCarsControllerProvider.notifier).loadNext();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myCarsControllerProvider);
    final ctrl = ref.read(myCarsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('My Cars')),
      body: RefreshIndicator(
        onRefresh: () => ref.read(myCarsControllerProvider.notifier).loadInitial(),
        child: CustomScrollView(
          controller: _scroll,
          slivers: [
            SliverToBoxAdapter(child: _ShowcaseBar()),
            SliverToBoxAdapter(child: _FiltersBar()),
            if (state.error != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(TdxSpace.m),
                  child: Text(state.error!, style: const TextStyle(color: Colors.red)),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: TdxSpace.m),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final car = state.items[index];
                    return MyCarCard(
                      car: car,
                      onAddToShowcase: () async {
                        if (state.showcase.length < 3) {
                          await ctrl.addToShowcase(car.id);
                          return;
                        }
                        final idx = await showModalBottomSheet<int>(
                          context: context,
                          builder: (_) => _ChooseSlotSheet(current: state.showcase),
                        );
                        if (idx != null) {
                          await ctrl.replaceShowcase(index: idx, carId: car.id);
                        }
                      },
                    );
                  },
                  childCount: state.items.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(TdxSpace.m),
                child: Center(
                  child: state.loading
                      ? const CircularProgressIndicator()
                      : Text(
                    state.nextCursor == null ? 'End of list' : 'Scroll to load more',
                    style: TextStyle(color: TdxColors.textPrimary.withOpacity(.6)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShowcaseBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(myCarsControllerProvider);
    final ctrl = ref.read(myCarsControllerProvider.notifier);

    Widget slot(String? carId) {
      final filled = carId != null;
      return GestureDetector(
        onTap: filled ? () => ctrl.removeFromShowcase(carId!) : null,
        child: Container(
          width: 86,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: TdxRadius.card,
            border: Border.all(color: TdxColors.neutral300),
            color: TdxColors.neutral100,
          ),
          alignment: Alignment.center,
          child: filled
              ? const Icon(Icons.star, color: Colors.amber)
              : const Icon(Icons.star_border),
        ),
      );
    }

    final List<String?> ids = [...s.showcase];
    while (ids.length < 3) ids.add(null);

    return Padding(
      padding: const EdgeInsets.all(TdxSpace.m),
      child: Row(
        children: [
          const Text('Showcase', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(width: 12),
          ...ids.map(slot).expand((w) => [w, const SizedBox(width: 8)]).toList()..removeLast(),
          const Spacer(),
          Text('${s.showcase.length}/3',
              style: TextStyle(color: TdxColors.textPrimary.withOpacity(.6))),
        ],
      ),
    );
  }
}

class _FiltersBar extends ConsumerWidget {
  const _FiltersBar({Key? key}) : super(key: key);

  Rarity? _rarityFromLabel(String lbl) {
    switch (lbl) {
      case 'Common':
        return Rarity.common;
      case 'Rare':
        return Rarity.rare;
      case 'Epic':
        return Rarity.epic;
      case 'Legendary':
        return Rarity.legendary;
      default:
        return null;
    }
  }

  String _rarityLabel(Rarity? r) => r?.label ?? 'All';

  String _bodyLabel(BodyType? b) {
    switch (b) {
      case BodyType.sedan:
        return 'Sedan';
      case BodyType.suv:
        return 'SUV';
      case BodyType.pickup:
        return 'Pickup';
      case BodyType.coupe:
        return 'Coupe';
      default:
        return 'All';
    }
  }

  BodyType? _bodyFromLabel(String lbl) {
    switch (lbl) {
      case 'Sedan':
        return BodyType.sedan;
      case 'SUV':
        return BodyType.suv;
      case 'Pickup':
        return BodyType.pickup;
      case 'Coupe':
        return BodyType.coupe;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(myCarsControllerProvider);
    final ctrl = ref.read(myCarsControllerProvider.notifier);
    final brandsAsync = ref.watch(myCarsBrandsProvider);

    final rarityValue = _rarityLabel(s.rarity);
    final bodyValue = _bodyLabel(s.bodyType);
    final brandValue = s.brand ?? 'All';

    return Padding(
      padding: const EdgeInsets.fromLTRB(TdxSpace.m, 0, TdxSpace.m, TdxSpace.s),
      child: TdxFilterBar(
        child: LayoutBuilder(
          builder: (context, c) {
            final itemWidth = (c.maxWidth - 16) / 2;

            return Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: itemWidth,
                  child: brandsAsync.when(
                    data: (brands) {
                      final items = <String>['All', ...brands.take(50)];
                      return TdxDropdown<String>(
                        label: 'Brand',
                        items: items,
                        value: brandValue,
                        onChanged: (v) {
                          final sel = v ?? 'All';
                          ctrl.setBrand(sel == 'All' ? null : sel);
                        },
                        getLabel: (v) => v,
                      );
                    },
                    loading: () => const TdxDropdown<String>(
                      label: 'Brand',
                      items: ['Loading…'],
                      value: 'Loading…',
                    ),
                    error: (_, __) => const TdxDropdown<String>(
                      label: 'Brand',
                      items: ['All'],
                      value: 'All',
                    ),
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: TdxDropdown<String>(
                    label: 'Rarity',
                    items: const ['All', 'Common', 'Rare', 'Epic', 'Legendary'],
                    value: rarityValue,
                    onChanged: (v) => ctrl.setRarity(_rarityFromLabel(v ?? 'All')),
                    getLabel: (v) => v,
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: TdxDropdown<String>(
                    label: 'Body type',
                    items: const ['All', 'Sedan', 'SUV', 'Pickup', 'Coupe'],
                    value: bodyValue,
                    onChanged: (v) => ctrl.setBodyType(_bodyFromLabel(v ?? 'All')),
                    getLabel: (v) => v,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ChooseSlotSheet extends StatelessWidget {
  const _ChooseSlotSheet({required this.current});
  final List<String> current;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(title: Text('Replace a showcase slot')),
          for (var i = 0; i < current.length; i++)
            ListTile(
              leading: const Icon(Icons.star),
              title: Text('Slot ${i + 1}'),
              subtitle: Text('Vehicle ID: ${current[i]}'),
              onTap: () => Navigator.pop(context, i),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
