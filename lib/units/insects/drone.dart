import 'package:flame/components.dart';

import '../unit.dart';

class Drone extends Unit {
  static const int droneHp = 50;
  static const int droneSpeed = 50;

  Drone({
    required Block block,
    Vector2? size,
    int? priority,
  }) : super(
          hp: droneHp,
          speed: droneSpeed,
          size: size,
          priority: priority,
                    block: block,

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
