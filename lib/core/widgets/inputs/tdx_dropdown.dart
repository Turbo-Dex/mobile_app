import 'package:flutter/material.dart';

class TdxDropdown<T> extends StatelessWidget {
  const TdxDropdown({
    Key? key,
    required this.label,
    required this.items,
    required this.value,
    this.onChanged,
    this.getLabel,
  }) : super(key: key);

  final String label;
  final List<T> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String Function(T value)? getLabel;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items
          .map((e) => DropdownMenuItem<T>(
        value: e,
        child: Text(getLabel != null ? getLabel!(e) : e.toString()),
      ))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
      ),
      borderRadius: BorderRadius.circular(12),
    );
  }
}
