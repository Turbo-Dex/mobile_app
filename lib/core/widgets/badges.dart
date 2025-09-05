import 'package:flutter/material.dart';
import '../design/tokens.dart';
import '../../app/theme/colors.dart';

class TdxBadge extends StatelessWidget {
  const TdxBadge({
    Key? key,
    required this.label,
    this.icon,
    this.color,
    this.onTap,
  }) : super(key: key);

  final String label;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fg = color ?? TdxColors.neutral600;
    final bg = (color ?? TdxColors.neutral600).withValues(alpha:0.08);

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
        ],
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: fg,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    final decorated = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: content,
    );

    return onTap == null
        ? decorated
        : InkWell(borderRadius: BorderRadius.circular(20), onTap: onTap, child: decorated);
  }
}

class ScopeBadge extends StatelessWidget {
  const ScopeBadge.friends({Key? key}) : _label = 'Friends', _icon = Icons.group_outlined, super(key: key);
  const ScopeBadge.world({Key? key}) : _label = 'World', _icon = Icons.public_outlined, super(key: key);

  final String _label;
  final IconData _icon;

  @override
  Widget build(BuildContext context) => TdxBadge(label: _label, icon: _icon);
}

class LocationBadge extends StatelessWidget {
  const LocationBadge({Key? key, required this.city, required this.country}) : super(key: key);
  final String city;
  final String country;

  @override
  Widget build(BuildContext context) => TdxBadge(
    label: '$city, $country',
    icon: Icons.location_on_outlined,
  );
}
