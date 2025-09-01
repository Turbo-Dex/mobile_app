import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_app/core/design/tokens.dart';
import 'package:mobile_app/core/widgets/filters/index.dart';
import 'package:mobile_app/features/turbodex/controller/turbodex_controller.dart';
import 'package:mobile_app/features/turbodex/model/dex_sort.dart';
import 'package:mobile_app/features/turbodex/view/widgets/dex_card.dart';

class TurboDexPage extends ConsumerStatefulWidget {
  const TurboDexPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TurboDexPage> createState() => _TurboDexPageState();
}

class _TurboDexPageState extends ConsumerState<TurboDexPage> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(turbodexControllerProvider.notifier).refresh();
    _scroll.addListener(() {
      final p = _scroll.position;
      if (p.pixels > p.maxScrollExtent - 600) {
        ref.read(turbodexControllerProvider.notifier).nextPage();
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
    final state = ref.watch(turbodexControllerProvider);
    final ctrl = ref.read(turbodexControllerProvider.notifier);

    return CustomScrollView(
      controller: _scroll,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(TdxSpace.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TurboDex', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 6),
                LinearProgressIndicator(value: state.completion),
                const SizedBox(height: 6),
                Text('${state.captured}/${state.total} captured • ${(state.completion * 100).toStringAsFixed(1)}%'),
              ],
            ),
          ),
        ),

        // TRI : Number | Rarity (texte noir via DS)
        SliverToBoxAdapter(
          child: TdxFilterBar(
            leading: Icons.sort,
            child: TdxSegmented<DexSort>(
              segments: const [
                ButtonSegment(
                  value: DexSort.number,
                  label: Text('Number'),
                  icon: Icon(Icons.format_list_numbered),
                ),
                ButtonSegment(
                  value: DexSort.rarity,
                  label: Text('Rarity'),
                  icon: Icon(Icons.star_outline),
                ),
              ],
              selected: {state.sort},
              onChanged: (s) => ctrl.setSort(s.first),
            ),
          ),
        ),

        if (state.error != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(TdxSpace.m),
              child: Text(
                state.error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ),

        SliverPadding(
          padding: const EdgeInsets.all(TdxSpace.s),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (context, i) => DexCard(entry: state.items[i]),
              childCount: state.items.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.82,
            ),
          ),
        ),
// SliverToBoxAdapter(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: TdxSpace.m, vertical: TdxSpace.s),
            child: Row(
              children: const [
                Icon(Icons.sort),
                SizedBox(width: 8),
                Text('Sorted by rarity'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
