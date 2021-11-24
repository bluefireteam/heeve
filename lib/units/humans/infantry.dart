import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

import '../unit.dart';

class Infantry extends Unit {
  static const int infantryHp = 50;
  static const int infantrySpeed = 50;

  Infantry({
    required Vector2 position,
  }) : super(
          position: position,
          hp: infantryHp,
          speed: infantrySpeed,
          size: Vector2(50, 50),
          priority: 10,
          anchor: Anchor.bottomCenter,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addHitbox(HitboxRectangle(relation: Vector2(0.3, 0.7)));
  }

  @override
  String get moveAsset => 'humans/infantry.fa';

  @override
  String get idleAsset => 'humans/infantry-idle.fa';

  @override
  String get attackAsset => 'humans/infantry-attack.fa';

  @override
  String get dieAsset => 'humans/infantry-die.fa';
}
