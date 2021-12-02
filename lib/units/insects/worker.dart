import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

import '../unit.dart';

class Worker extends Unit with HasHitboxes, Collidable {
  static const int workerHp = 15;
  static const int workerSpeed = 60;

  Worker({
    Vector2? position,
  }) : super(
          position: position,
          hp: workerHp,
          speed: workerSpeed,
          size: Vector2.all(40),
          anchor: const Anchor(0.5, 0.75),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addHitbox(HitboxCircle());
  }

  /// The exact point within the sprite where bullets should be shot/hit.
  @override
  Vector2 get bulletPosition => position - Vector2(0, height / 4);

  @override
  String get moveAsset => 'heeves/worker.fa';

  @override
  String get idleAsset => 'heeves/worker-idle.fa';
}
