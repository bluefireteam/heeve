import 'package:flame/components.dart';

import '../unit.dart';

class Worker extends Unit {
  static const int workerHp = 10;
  static const int workerSpeed = 10;

  Worker({
    required Vector2 position,
    Vector2? size,
    int? priority,
  }) : super(
          position: position,
          hp: workerHp,
          speed: workerSpeed,
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
