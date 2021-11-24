import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class Selector extends Component {
  @override
  int get priority => 5;

  static final _selectorPaint = Paint()
    ..color = BasicPalette.red.color
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  Vector2? selectionStart, selectionEnd;

  @override
  void render(Canvas c) {
    final start = selectionStart;
    final end = selectionEnd;
    if (start == null || end == null) {
      return;
    }

    c.drawRect(start & (end - start), _selectorPaint);
  }
}
