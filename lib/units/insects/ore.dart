import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';

import '../../heeve_game.dart';

enum OreState {
  ore1,
  ore2,
  depleted1,
  depleted2,
}

class Ore extends SpriteGroupComponent<OreState> with HasGameRef<HeeveGame> {
  static Random rng = Random();
  bool isDepleted;

  Ore({Vector2? position, this.isDepleted = false})
      : super(
          position: position,
          size: Vector2.all(50),
          anchor: Anchor.bottomCenter,
          priority: 1,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final atlas = await gameRef.loadFireAtlas('sprites/nivurium-ore.fa');
    sprites = {
      OreState.ore1: atlas.getSprite('ore-1'),
      OreState.ore2: atlas.getSprite('ore-2'),
      OreState.depleted1: atlas.getSprite('depleted-1'),
      OreState.depleted2: atlas.getSprite('depleted-2'),
    };
    isDepleted = rng.nextBool(); // TODO(spydon): Just for testing visually
    if (!isDepleted) {
      current = rng.nextBool() ? OreState.ore1 : OreState.ore2;
    } else {
      current = rng.nextBool() ? OreState.depleted1 : OreState.depleted2;
    }
  }
}
