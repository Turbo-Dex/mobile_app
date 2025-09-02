import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/tokens.dart';
import '../controller/feed_controller.dart';
import 'widgets/vehicle_card.dart';
import '../data/feed_api.dart' show FeedScope;
import '../../../core/widgets/filters/index.dart';

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(feedControllerProvider.notifier).refresh();
    _scroll.addListener(() {
      final c = _scroll.position;
      if (c.pixels > c.maxScrollExtent - 600) {
        ref.read(feedControllerProvider.notifier).nextPage();
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
    final state = ref.watch(feedControllerProvider);
    final ctrl = ref.read(feedControllerProvider.notifier);

    return RefreshIndicator(
      onRefresh: ctrl.refresh,
      child: CustomScrollView(
        controller: _scroll,
        slivers: [
          SliverToBoxAdapter(
            child: TdxFilterBar(
              leading: Icons.filter_list,
              child: TdxSegmented<FeedScope>(
                segments: const [
                  ButtonSegment(value: FeedScope.world,  label: Text('World'),  icon: Icon(Icons.public)),
                  ButtonSegment(value: FeedScope.friends,label: Text('Friends'),icon: Icon(Icons.group_outlined)),
                ],
                selected: {state.scope},
                onChanged: (s) => ctrl.setScope(s.first),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _askReportReason(BuildContext context) async {
    final ctrl = TextEditingController();
    return showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(TdxSpace.m),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Report post', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: ctrl,
              decoration: const InputDecoration(labelText: 'Reason (optional)'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))),
                const SizedBox(width: 8),
                Expanded(child: ElevatedButton(onPressed: () => Navigator.pop(context, ctrl.text.trim().isEmpty ? 'inappropriate' : ctrl.text.trim()), child: const Text('Send'))),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
