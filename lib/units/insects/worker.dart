import 'package:flame/components.dart';

import '../unit.dart';

class Worker extends Unit {
  static const int workerHp = 10;
  static const int workerSpeed = 60;

  Worker({
    Vector2? position,
  }) : super(
          position: position,
          hp: workerHp,
          speed: workerSpeed,
          size: Vector2.all(50),
          anchor: const Anchor(0.5, 0.75),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    //addHitbox(HitboxRectangle(relation: Vector2(0.3, 0.7)));
  }

  @override
  String get moveAsset => 'heeves/worker.fa';

  @override
  String get idleAsset => 'heeves/worker-idle.fa';
}
