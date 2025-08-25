import 'package:flutter/material.dart';

class TdxButton extends StatelessWidget {
  const TdxButton.primary({Key? key, required this.label, this.onPressed, this.icon})
      : _type = _TdxBtnType.primary, super(key: key);

  const TdxButton.secondary({Key? key, required this.label, this.onPressed, this.icon})
      : _type = _TdxBtnType.secondary, super(key: key);

  const TdxButton.ghost({Key? key, required this.label, this.onPressed, this.icon})
      : _type = _TdxBtnType.ghost, super(key: key);

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final _TdxBtnType _type;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        Text(label),
      ],
    );

    switch (_type) {
      case _TdxBtnType.primary:
        return ElevatedButton(onPressed: onPressed, child: child);
      case _TdxBtnType.secondary:
        return OutlinedButton(onPressed: onPressed, child: child);
      case _TdxBtnType.ghost:
        return TextButton(onPressed: onPressed, child: child);
    }
  }
}

enum _TdxBtnType { primary, secondary, ghost }
