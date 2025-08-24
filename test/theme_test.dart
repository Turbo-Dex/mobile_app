import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/theme/theme.dart';
import 'package:mobile_app/app/theme/colors.dart';

void main() {
  test('Primary color is red and background is off-white', () {
    final theme = TurboDexTheme.light();
    expect(theme.colorScheme.primary, const Color(0xFFCC0605)); // red
    expect(theme.scaffoldBackgroundColor, const Color(0xFFF5F3ED)); // off-white
  });

  test('Uses Material 3', () {
    final theme = TurboDexTheme.light();
    expect(theme.useMaterial3, true);
  });
}
