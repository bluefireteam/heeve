import 'dart:math';

import 'package:flame/components.dart';

import '../building.dart';
import 'butterfly.dart';

class Ore extends Building {
  static const oreHp = 100;
  static Random rng = Random();

  @override
  final bool hasFireAtlas = true;

  @override
  final bool selectable = false;

  @override
  final bool movable = false;

  Ore()
      : super(
          hp: oreHp,
          size: Vector2.all(25),
          anchor: const Anchor(0.5, 0.75),
        );

  @override
  String get idleAsset => 'nivurium-ore-idle.fa';

  @override
  String get dieAsset => 'nivurium-ore-die.fa';

  /// The exact point within the sprite where bullets should be shot/hit.
  @override
  Vector2 get bulletPosition => position - Vector2(0, height / 4);

  @override
  void update(double dt) {
    super.update(dt);
    if (isDead &&
        timeSinceSpawn > spawnRate &&
        map.children.query<Butterfly>().length < maxPopulation) {
      timeSinceSpawn = 0;
      map.addOnBlock(
        Butterfly(),
        map.findCloseValidBlock(
          block,
          random: true,
        ),
      );
    }
  }
}
