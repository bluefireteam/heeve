import 'package:flame/components.dart';

import '../unit.dart';

class Infantry extends Unit {
  static const int infantryHp = 50;
  static const int infantrySpeed = 50;

  Infantry(
    Vector2? position,
    Vector2? size,
    int? priority,
  ) : super(
          hp: infantryHp,
          speed: infantrySpeed,
          position: position,
          size: size,
          priority: priority,
        );

  Future<void> onLoad() async {
    await super.onLoad();
    // Sub classes should set up animation groups here
  }
}
