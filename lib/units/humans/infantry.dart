import 'package:flame/components.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';
import 'package:heeve/units/unit_animation_state.dart';

import '../unit.dart';

class Infantry extends Unit {
  static const int infantryHp = 50;
  static const int infantrySpeed = 50;

  Block block;

  Infantry({
    required this.block,
  }) : super(
          hp: infantryHp,
          speed: infantrySpeed,
          size: Vector2(50, 50),
          priority: 10,
        );

  @override
  void update(double dt) {
    super.update(dt);

    position = gameRef.map.getBlockPosition(block);// - offset;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Sub classes should set up animation groups here

    final atlas = await gameRef.loadFireAtlas(
      'sprites/humans/foot-soldier.fa',
    );

    animations = {
      const UnitAnimationState(
          animation: AnimationState.idle,
          direction: DirectionState.up,
      ): atlas.getAnimation('up-left'),
      const UnitAnimationState(
          animation: AnimationState.idle,
          direction: DirectionState.down,
      ): atlas.getAnimation('down-left'),
      const UnitAnimationState(
          animation: AnimationState.idle,
          direction: DirectionState.left,
      ): atlas.getAnimation('up-left'),
      const UnitAnimationState(
          animation: AnimationState.idle,
          direction: DirectionState.right,
      ): atlas.getAnimation('up-left'),
      const UnitAnimationState(
          animation: AnimationState.moving,
          direction: DirectionState.up,
      ): atlas.getAnimation('up-left'),
      const UnitAnimationState(
          animation: AnimationState.moving,
          direction: DirectionState.down,
      ): atlas.getAnimation('up-left'),
      const UnitAnimationState(
          animation: AnimationState.moving,
          direction: DirectionState.left,
      ): atlas.getAnimation('up-left'),
      const UnitAnimationState(
          animation: AnimationState.moving,
          direction: DirectionState.right,
      ): atlas.getAnimation('up-right'),
    };
  }
}
