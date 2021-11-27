import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class LifeBar {
  static final _border = BasicPalette.white.paint();
  static final _bg = BasicPalette.black.paint();
  static final _bar = BasicPalette.green.paint();
  static void render(
    Canvas canvas,
    Vector2 p,
    Vector2 size,
    double fraction,
  ) {
    canvas.drawRect((p & size).inflate(0.5), _border);
    canvas.drawRect(p & size, _bg);
    final fracSize = Vector2(size.x * fraction.clamp(0, 1), size.y);
    canvas.drawRect((p & fracSize).deflate(0.5), _bar);
  }
}
