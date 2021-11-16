import 'package:flame/components.dart';

import '../unit.dart';

class Drone extends Unit {
  static const int droneHp = 50;
  static const int droneSpeed = 50;

  Drone({
    required Vector2 position,
    Vector2? size,
    int? priority,
  }) : super(
          position: position,
          hp: droneHp,
          speed: droneSpeed,
          size: size,
          priority: priority,
        );

  @override
  String get movingAsset => '';
  @override
  String get idleAsset => '';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Sub classes should set up animation groups here
  }
}
