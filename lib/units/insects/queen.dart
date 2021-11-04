import 'package:flame/components.dart';

import '../unit.dart';

class Queen extends Unit {
  static const int queenHp = 1000;
  static const int queenSpeed = 1000;

  Queen(
    Vector2? position,
    Vector2? size,
    int? priority,
  ) : super(
          hp: queenHp,
          speed: queenSpeed,
          position: position,
          size: size,
          priority: priority,
        );

  Future<void> onLoad() async {
    await super.onLoad();
    // Sub classes should set up animation groups here
  }
}
