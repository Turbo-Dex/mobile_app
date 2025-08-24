// Define a reusable intelligent scaffold widget

import 'package:flutter/material.dart';

class TdxScaffold extends StatelessWidget {
  const TdxScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
  });

  final Widget body; //Main content
  final String? title; // Title (option)
  final List<Widget>? actions; // App-bar actions (option)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title == null
          ? null
          : AppBar(
        title: Text(title!),
        actions: actions,
      ),
      body: SafeArea(child: body),
    );
  }
}
