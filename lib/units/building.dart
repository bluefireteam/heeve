import 'package:flame/components.dart';

import 'unit.dart';

abstract class Building extends Unit {
  Building({
    required int hp,
    required Block block,
    Vector2? size,
    int? priority,
  }) : super(
          hp: hp,
          speed: 0,
          size: size,
          priority: priority,
          block: block,
        );
}
