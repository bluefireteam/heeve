import 'package:flame/components.dart';

import '../unit.dart';

class FlameThrower extends Unit {
  static const int flameThrowerHp = 50;
  static const int flameThrowerSpeed = 50;

  FlameThrower({
    required Block block,
    Vector2? size,
    int? priority,
  }) : super(
          hp: flameThrowerHp,
          speed: flameThrowerSpeed,
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
