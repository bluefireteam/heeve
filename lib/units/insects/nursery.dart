import 'package:flame/components.dart';

import '../building.dart';

class Nursery extends Building {
  static const int nurseryHp = 1000;
  static const int nurseryCost = 10;

  Nursery({
    required Vector2 position,
    Vector2? size,
    int? priority,
  }) : super(
          hp: nurseryHp,
          cost: nurseryCost,
          position: position,
          size: size,
          priority: priority,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Sub classes should set up animation groups here
  }
}
