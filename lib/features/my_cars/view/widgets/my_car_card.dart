import 'package:flutter/material.dart';
import 'package:mobile_app/app/theme/colors.dart';
import 'package:mobile_app/core/design/tokens.dart';
import 'package:mobile_app/core/widgets/rarity.dart';
import 'package:mobile_app/features/my_cars/model/user_car.dart';

class MyCarCard extends StatelessWidget {
  const MyCarCard({
    super.key,
    required this.car,
    required this.onAddToShowcase,
  });

  final UserCar car;
  final VoidCallback onAddToShowcase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: TdxRadius.chip),
      elevation: 1,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.6,
              child: Image.network(
                car.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: TdxColors.neutral200),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TdxSpace.s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          car.modelName,
                          style: theme.textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      RarityChip(rarity: car.rarity),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${car.brandName}${car.colorName != null ? ' • ${car.colorName}' : ''}',
                    style: theme.textTheme.bodySmall!
                        .copyWith(color: TdxColors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          car.cityCountryLabel,
                          style: theme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if ((car.modelShortDescription ?? '').isNotEmpty)
                    Text(
                      car.modelShortDescription!,
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _date(car.capturedAt),
                          style: theme.textTheme.labelSmall!
                              .copyWith(color: TdxColors.textSecondary),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.star_border),
                        tooltip: 'Add to showcase',
                        onPressed: onAddToShowcase,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _date(DateTime dt) {
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '${dt.year}-$m-$d';
  }
}
