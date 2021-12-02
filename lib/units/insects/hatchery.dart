import 'package:flame/components.dart';

import '../building.dart';
import 'worker.dart';

class Hatchery extends Building {
  static const int nurseryHp = 1000;
  static const int nurseryCost = 10;

  Hatchery({
    Vector2? position,
  }) : super(
          hp: nurseryHp,
          cost: nurseryCost,
          position: position,
          size: Vector2(15, 17.5),
          anchor: const Anchor(0.5, 0.75),
        );

  @override
  String get idleAsset => 'hatchery.png';

  @override
  void update(double dt) {
    if (!isActive) {
      return;
    }
    super.update(dt);
    if (timeSinceSpawn > spawnRate &&
        gameRef.map.children.query<Worker>().length < maxPopulation) {
      gameRef.map.addOnBlock(
        Worker(),
        map.findCloseValidBlock(
          block,
          random: true,
        ),
      );
      timeSinceSpawn = 0;
    }
  }
}
