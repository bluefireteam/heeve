import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

import '../insects/worker.dart';
import '../unit.dart';

class Infantry extends Unit with HasHitboxes, Collidable {
  static const int infantryHp = 100;
  static const int infantrySpeed = 50;

  @override
  final bool movable = false;

  Infantry({
    Vector2? position,
  }) : super(
          position: position,
          hp: infantryHp,
          speed: infantrySpeed,
          size: Vector2(50, 50),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addHitbox(HitboxCircle(normalizedRadius: 0.5));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (attackTarget == null && attackedBy.isNotEmpty) {
      path.clear();
      attackTarget = (attackedBy..shuffle()).first;
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    if (other is Worker && !other.isDead) {
      attack(other);
    }
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
