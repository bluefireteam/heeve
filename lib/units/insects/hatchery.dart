import 'package:flame/components.dart';

import '../building.dart';
import 'worker.dart';

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
          size: Vector2.all(50),
          priority: 1,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('hatchery.png');
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
      gameRef.map.addOnBlock(Worker(), block);
      _timeSinceSpawn = 0;
    }
  }
}
