import 'package:flame/components.dart';

import 'unit.dart';

class Building extends Unit {
  Building({
    required int hp,
    Vector2? position,
    Vector2? size,
    int? priority,
  }) : super(
          hp: hp,
          speed: 0,
          position: position,
          size: size,
          priority: priority,
        );
}
