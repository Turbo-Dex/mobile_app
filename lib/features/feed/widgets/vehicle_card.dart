import 'package:flutter/material.dart';
import '../../../app/theme/colors.dart';
import '../../../core/design/tokens.dart';
import '../../../core/utils/time_ago.dart';
import '../../../core/widgets/rarity.dart';
import '../../../core/widgets/badges.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    Key? key,
    required this.rarity,
    required this.takenAt,
    required this.city,
    required this.country,
    required this.brand,
    required this.model,
    this.onTap,
    this.onLike,
    this.onShare,
    this.onReport,
    this.likeCount = 0,
    this.likedByMe = false,
  }) : super(key: key);

  final Rarity rarity;
  final DateTime takenAt;
  final String city;
  final String country;
  final String brand;
  final String model;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onShare;
  final VoidCallback? onReport;
  final int likeCount;
  final bool likedByMe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: TdxRadius.card,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: TdxRadius.card,
          border: const Border.fromBorderSide(BorderSide(color: TdxColors.neutral200)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image (placeholder pour l'instant)
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Container(
                color: Colors.black12,
                child: const Center(
                  child: Icon(Icons.directions_car_filled_outlined, size: 64),
                ),
              ),
            ),
            const Divider(height: 1, color: TdxColors.neutral200),

            Padding(
              padding: const EdgeInsets.all(TdxSpace.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: rarity + time ago + location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RarityChip(rarity: rarity),
                      const SizedBox(width: TdxSpace.m),
                      Expanded(
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            TdxBadge(
                              label: timeAgoFromNow(takenAt),
                              icon: Icons.access_time,
                            ),
                            LocationBadge(city: city, country: country),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TdxSpace.m),

                  Text(
                    '$brand $model',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: TdxSpace.m),

                  Row(
                    children: [
                      _ActionIcon(
                        icon: likedByMe ? Icons.favorite : Icons.favorite_border,
                        onTap: onLike,
                      ),
                      const SizedBox(width: 6),
                      Text('$likeCount', style: theme.textTheme.bodySmall),
                      const Spacer(),
                      _ActionIcon(icon: Icons.ios_share, onTap: onShare),
                      const SizedBox(width: 8),
                      _ActionIcon(icon: Icons.flag_outlined, onTap: onReport),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({Key? key, required this.icon, this.onTap}) : super(key: key);
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(icon, size: 20),
      ),
    );
  }
}
