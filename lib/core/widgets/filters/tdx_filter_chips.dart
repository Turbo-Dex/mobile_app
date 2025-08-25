import 'package:flutter/material.dart';

class TdxMultiFilter<T> extends StatelessWidget {
  const TdxMultiFilter({
    Key? key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.leading,
  }) : super(key: key);

  final List<T> options;
  final Set<T> selected;
  final void Function(Set<T>) onChanged;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((o) {
        final isSelected = selected.contains(o);
        return FilterChip(
          label: Text(
            o.toString(),
            style: const TextStyle(color: Colors.black), // <-- texte noir
          ),
          avatar: leading,
          selected: isSelected,
          onSelected: (_) {
            final next = Set<T>.from(selected);
            isSelected ? next.remove(o) : next.add(o);
            onChanged(next);
          },
        );
      }).toList(),
    );
  }
}
