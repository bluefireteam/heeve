import 'package:flame/components.dart';

import '../building.dart';
import '../unit.dart';
import 'infantry.dart';
import 'infantry_group.dart';

class Spaceship extends Building {
  static const int spaceshipHp = 1000;
  late final InfantryGroup group;

  Spaceship({
    Vector2? position,
  }) : super(
          hp: spaceshipHp,
          position: position,
          size: Vector2(48, 60),
          anchor: Anchor.center,
        );

  @override
  String get idleAsset => 'human-spaceship.png';

  /// The exact point within the sprite where bullets should be shot/hit.
  @override
  Vector2 get bulletPosition => position - Vector2(0, height / 3);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    group = InfantryGroup();
    add(group);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (attackedBy.isNotEmpty &&
        group.units.any((u) => u.attackTarget == null)) {
      Unit randomAttacker() => (attackedBy..shuffle()).first;
      group.units.forEach((u) {
        u.moveToBlock(map.findCloseValidBlock(block));
        u.attackTarget = randomAttacker();
      });
    }
    if (timeSinceSpawn > spawnRate &&
        gameRef.map.children.query<Infantry>().length < maxPopulation) {
      final infantry = Infantry();
      group.units.add(infantry);
      gameRef.map.addOnBlock(infantry, map.findCloseValidBlock(block));
      timeSinceSpawn = 0;
    }
  }

  @override
  void onRemove() {
    gameRef.map.occupiedBlocks.remove(group.groupTarget);
    super.onRemove();
  }
}
