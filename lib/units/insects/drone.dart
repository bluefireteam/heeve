import 'package:flame/components.dart';

import '../unit.dart';

class Drone extends Unit {
  static const int droneHp = 50;
  static const int droneSpeed = 50;

  Drone(
    Vector2? position,
    Vector2? size,
    int? priority,
  ) : super(
          hp: droneHp,
          speed: droneSpeed,
          position: position,
          size: size,
          priority: priority,
        );

  Future<void> onLoad() async {
    await super.onLoad();
    // Sub classes should set up animation groups here
  }
}
