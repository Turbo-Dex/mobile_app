import 'package:flutter/material.dart';
import '../../../app/theme/colors.dart';
import '../../icons/tdx_icons.dart';

class TdxTextField extends StatefulWidget {
  const TdxTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefix,
    this.suffix,
    this.obscure = false,
    this.validator,
    this.textInputAction,
    this.keyboardType,
    this.onChanged,
    this.maxLines = 1,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final String? hint;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscure;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  @override
  State<TdxTextField> createState() => _TdxTextFieldState();
}

class _TdxTextFieldState extends State<TdxTextField> {
  bool _obscure = false;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefix,
        suffixIcon: widget.obscure
            ? IconButton(
          icon: Icon(_obscure ? TdxIcons.visibilityOff : TdxIcons.visibilityOn),
          color: TdxColors.neutral600,
          onPressed: () => setState(() => _obscure = !_obscure),
        )
            : widget.suffix,
      ),
    );
  }
}
