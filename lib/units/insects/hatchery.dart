import 'package:flame/components.dart';
import 'package:heeve/units/insects/worker.dart';

import '../building.dart';

class Hatchery extends Building {
  static const int nurseryHp = 1000;
  static const int nurseryCost = 1;
  static const int spawnRate = 30;
  static const int maxWorkers = 10;
  double _timeSinceSpawn = 30;

  Hatchery({
    Vector2? position,
  }) : super(
          hp: nurseryHp,
          cost: nurseryCost,
          position: position,
          size: Vector2(15, 17.5),
        );

  @override
  String get idleAsset => 'hatchery.png';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void update(double dt) {
    if (!isActive) {
      return;
    }
    super.update(dt);
    _timeSinceSpawn += dt;
    if (_timeSinceSpawn > spawnRate &&
        gameRef.map.children.query<Worker>().length < maxWorkers) {
      gameRef.map.addOnBlock(Worker(), map.findCloseValidBlock(block));
      _timeSinceSpawn = 0;
    }
  }
}
