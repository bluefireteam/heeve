import 'dart:ui';

import 'package:flame/components.dart';

extension BlockExtension on Block {
  Offset toOffset() => Offset(x.toDouble(), y.toDouble());
}
