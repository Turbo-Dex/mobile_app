import 'package:flutter/material.dart';
import '../../design/tokens.dart';
import '../../../app/theme/colors.dart';

class TdxFilterBar extends StatelessWidget {
  const TdxFilterBar({
    Key? key,
    required this.child,
    this.leading,
  }) : super(key: key);

  final Widget child;
  final IconData? leading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TdxSpace.m),
      padding: const EdgeInsets.all(TdxSpace.s),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: TdxRadius.card,
        border: Border.all(color: TdxColors.neutral200),
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            Icon(leading, color: TdxColors.textSecondary, size: 20),
            const SizedBox(width: 8),
          ],
          Expanded(child: child),
        ],
      ),
    );
  }
}
