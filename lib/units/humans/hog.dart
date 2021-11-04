import 'package:flame/components.dart';

import '../unit.dart';

class Hog extends Unit {
  static const int hogHp = 50;
  static const int hogSpeed = 50;

  Hog(
    Vector2? position,
    Vector2? size,
    int? priority,
  ) : super(
          hp: hogHp,
          speed: hogSpeed,
          position: position,
          size: size,
          priority: priority,
        );

  Future<void> onLoad() async {
    await super.onLoad();
    // Sub classes should set up animation groups here
  }
}
