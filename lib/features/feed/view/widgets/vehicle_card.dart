import 'package:flutter/material.dart';
import '../../../../core/design/tokens.dart';
import '../../../../core/widgets/rarity.dart' as ds;
import '../../model/feed_post.dart';

String _timeAgo(DateTime d) {
  final diff = DateTime.now().difference(d);
  if (diff.inMinutes < 1) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  return '${diff.inDays}d ago';
}

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    Key? key,
    required this.post,
    required this.onLike,
    required this.onReport,
    required this.onShare,
  }) : super(key: key);

  final FeedPost post;
  final VoidCallback onLike;
  final VoidCallback onReport;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final loc = [post.city, post.country].where((e) => (e ?? '').isNotEmpty).join(', ');
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: TdxSpace.m, vertical: TdxSpace.s),
      shape: RoundedRectangleBorder(borderRadius: TdxRadius.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header
          Padding(
            padding: const EdgeInsets.all(TdxSpace.m),
            child: Row(
              children: [
                CircleAvatar(radius: 18, backgroundImage: post.user.avatarUrl != null ? NetworkImage(post.user.avatarUrl!) : null),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.user.name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                      Text(_timeAgo(post.takenAt), style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                ds.RarityChip(rarity: post.rarity),
              ],
            ),
          ),

          // image
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(post.imageUrl, fit: BoxFit.cover),
            ),
          ),

          // meta
          Padding(
            padding: const EdgeInsets.fromLTRB(TdxSpace.m, TdxSpace.m, TdxSpace.m, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${post.make} ${post.model}', style: Theme.of(context).textTheme.titleMedium),
                if (loc.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16),
                      const SizedBox(width: 4),
                      Text(loc, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // actions
          Padding(
            padding: const EdgeInsets.all(TdxSpace.m),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(post.likedByMe ? Icons.favorite : Icons.favorite_border),
                  onPressed: onLike,
                ),
                Text('${post.likesCount}'),
                const SizedBox(width: 12),
                IconButton(icon: const Icon(Icons.ios_share), onPressed: onShare),
                const Spacer(),
                IconButton(icon: const Icon(Icons.flag_outlined), onPressed: onReport),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
