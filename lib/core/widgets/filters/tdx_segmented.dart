import 'package:flutter/material.dart';
import '../../design/tokens.dart';
import '../../../app/theme/colors.dart'; // <- idem

class TdxSegmented<T> extends StatelessWidget {
  const TdxSegmented({
    Key? key,
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.multi = false,
    this.showSelectedIcon = false,
  }) : super(key: key);

  final List<ButtonSegment<T>> segments;
  final Set<T> selected;
  final void Function(Set<T>) onChanged;
  final bool multi;
  final bool showSelectedIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = ButtonStyle(
      foregroundColor:
      MaterialStateProperty.resolveWith((_) => TdxColors.textPrimary),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return TdxColors.neutral100;
        return TdxColors.neutral100;
      }),
      side: const MaterialStatePropertyAll(
          BorderSide(color: TdxColors.neutral300)),
      shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: TdxRadius.pill)),
      padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
      textStyle: MaterialStatePropertyAll(
        theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    );

    return SegmentedButton<T>(
      style: style,
      segments: segments,
      selected: selected,
      onSelectionChanged: onChanged,
      multiSelectionEnabled: multi,
      showSelectedIcon: showSelectedIcon,
    );
  }
}
