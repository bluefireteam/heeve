import 'package:flame/components.dart';

import '../unit.dart';

class Worker extends Unit {
  static const int workerHp = 10;
  static const int workerSpeed = 10;

  Worker(
    Vector2? position,
    Vector2? size,
    int? priority,
  ) : super(
          hp: workerHp,
          speed: workerSpeed,
          position: position,
          size: size,
          priority: priority,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Sub classes should set up animation groups here
  }
}
