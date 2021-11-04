import 'package:flame/components.dart';

import '../unit.dart';

class Spitter extends Unit {
  static const int spitterHp = 25;
  static const int spitterSpeed = 25;

  Spitter(
    Vector2? position,
    Vector2? size,
    int? priority,
  ) : super(
          hp: spitterHp,
          speed: spitterSpeed,
          position: position,
          size: size,
          priority: priority,
        );

  Future<void> onLoad() async {
    await super.onLoad();
    // Sub classes should set up animation groups here
  }
}
