import 'package:flutter/material.dart';

class TdxAppBar extends AppBar {
  TdxAppBar({
    Key? key,
    required String titleText,
    List<Widget>? actions,
    bool center = false,
  }) : super(
    key: key,
    title: Text(titleText),
    centerTitle: center,
    actions: actions,
  );
}
