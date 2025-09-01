import 'package:flutter/material.dart';

class TdxSpace {
  static const s = 8.0;
  static const m = 12.0;
  static const l = 16.0;
  static const xl = 24.0;
}

class TdxRadius {
  static const r8 = Radius.circular(8);
  static const r12 = Radius.circular(12);
  static const r16 = Radius.circular(16);
  static const r24 = Radius.circular(24);
  static const card = BorderRadius.all(r16);
  static const BorderRadius chip = BorderRadius.all(Radius.circular(20));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
}
