import 'package:flame/components.dart';

import '../unit.dart';

class FlameThrower extends Unit {
  static const int flameThrowerHp = 50;
  static const int flameThrowerSpeed = 50;

  FlameThrower({
    required Vector2 position,
    Vector2? size,
    int? priority,
  }) : super(
          position: position,
          hp: flameThrowerHp,
          speed: flameThrowerSpeed,
          size: size,
          priority: priority,
        );

  @override
  String get moveAsset => '';
  @override
  String get idleAsset => '';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Sub classes should set up animation groups here
  }
}
