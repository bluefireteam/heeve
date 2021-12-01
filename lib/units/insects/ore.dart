import 'dart:math';

import 'package:flame/components.dart';

import '../unit.dart';
import 'butterfly.dart';

class Ore extends Unit {
  static const oreHp = 100;
  static const spawnRate = 10;
  static const maxButterflies = 20;
  static Random rng = Random();
  double _timeSinceSpawn = 0;

  @override
  final bool selectable = false;

  @override
  final bool movable = false;

  Ore()
      : super(
          hp: oreHp,
          speed: 0,
          size: Vector2.all(25),
          anchor: const Anchor(0.5, 0.75),
        );

  @override
  String get idleAsset => 'nivurium-ore-idle.fa';

  @override
  String get dieAsset => 'nivurium-ore-die.fa';

  @override
  void update(double dt) {
    super.update(dt);
    _timeSinceSpawn += dt;
    if (isDead &&
        _timeSinceSpawn > spawnRate &&
        gameRef.map.children.query<Butterfly>().length < maxButterflies) {
      _timeSinceSpawn = 0;
      gameRef.map.addOnBlock(Butterfly(), block);
    }
  }
}
