import 'dart:ui';

import 'package:flame/components.dart';

extension OffsetExtension on Offset {
  Block toBlock() => Block(dx.toInt(), dy.toInt());
}
