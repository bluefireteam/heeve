import 'package:flame/components.dart';

import '../unit.dart';

class FlameThrower extends Unit {
  static const int flameThrowerHp = 50;
  static const int flameThrowerSpeed = 50;

  FlameThrower(
    Vector2? position,
    Vector2? size,
    int? priority,
  ) : super(
          hp: flameThrowerHp,
          speed: flameThrowerSpeed,
          position: position,
          size: size,
          priority: priority,
        );

  Future<void> onLoad() async {
    await super.onLoad();
    // Sub classes should set up animation groups here
  }
}
