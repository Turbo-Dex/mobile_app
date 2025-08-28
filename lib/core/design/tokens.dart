import 'package:flutter/material.dart';

class TdxSpace {
  static const s = 8.0;
  static const m = 12.0;
  static const l = 16.0;
  static const xl = 24.0;
}

class TdxRadius {
  static final r8 = Radius.circular(8);
  static final r12 = Radius.circular(12);
  static final  r16 = Radius.circular(16);
  static final  r24 = Radius.circular(24);
  static final card = BorderRadius.all(r16);
  static final chip = BorderRadius.all(Radius.circular(20));
  static final pill = BorderRadius.all(Radius.circular(999));
}
