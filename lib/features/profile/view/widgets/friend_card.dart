import 'package:flutter/material.dart';
import '../../model/friend.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({
    super.key,
    required this.friend,
    this.onUnfollow,
  });

  final Friend friend;
  final VoidCallback? onUnfollow;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage:
              (friend.avatarUrl != null ? NetworkImage(friend.avatarUrl!) : null)
              as ImageProvider<Object>?,
              child: friend.avatarUrl == null
                  ? const Icon(Icons.person_outline)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(friend.displayName,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  Text('@${friend.username}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(3, (i) {
                      final img = i < friend.showcase.length ? friend.showcase[i] : null;
                      return Padding(
                        padding: EdgeInsets.only(right: i < 2 ? 6 : 0),
                        child: _ShowcaseThumb(imageUrl: img),
                      );
                    }),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Unfollow',
              onPressed: onUnfollow,
              icon: const Icon(Icons.person_remove_outlined),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShowcaseThumb extends StatelessWidget {
  const _ShowcaseThumb({this.imageUrl});
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 56,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: imageUrl == null
            ? const Icon(Icons.directions_car_outlined, size: 20)
            : Image.network(imageUrl!, fit: BoxFit.cover),
      ),
    );
  }
}
