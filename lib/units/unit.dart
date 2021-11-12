import 'package:flame/components.dart';
import 'package:heeve/units/unit_animation_state.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';

import '../heeve_game.dart';

/// A unit is anything that can be attacked and has different animations.
/// Example of units could be different types of insects, humans, building and
/// even things in the environment that should be possible to destroy, like
/// trees could be a [Unit].
///
/// All positions are anchored in the center.
abstract class Unit extends SpriteAnimationGroupComponent<UnitAnimationState>
    with HasHitboxes, Collidable, HasGameRef<HeeveGame> {
  final int hp;
  final int speed;
  
  Block block;
  Block? target;

  Unit({
    required this.hp,
    required this.speed,
    required this.block,
    Vector2? position,
    Vector2? size,
    int? priority,
  }) : super(
          current: const UnitAnimationState(
            animation: AnimationState.idle,
            direction: DirectionState.upLeft,
          ),
          position: position,
          size: size,
          anchor: Anchor.center,
          priority: priority,
        );

  String get movingAsset;
  String get idleAsset;

  String _formatDirectionState(DirectionState state) =>
      state.toString().split('.')[1];

  String _asset(String path) =>
      'sprites/$path';

  @override
  void update(double dt) {
    super.update(dt);

    position = gameRef.map.getBlockPosition(block);// - offset;
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    animations = {};

    final idleAtlas = await gameRef.loadFireAtlas(
        _asset(idleAsset),
    );

    DirectionState.values.forEach((directionState) {
      animations![
        UnitAnimationState(
            animation: AnimationState.idle,
            direction: directionState,
        )
      ] = idleAtlas.getAnimation(_formatDirectionState(directionState));
    });

    final movingAtlas = await gameRef.loadFireAtlas(
        _asset(movingAsset),
    );

    DirectionState.values.forEach((directionState) {
      animations![
        UnitAnimationState(
            animation: AnimationState.moving,
            direction: directionState,
        )
      ] = movingAtlas.getAnimation(_formatDirectionState(directionState));
    });
  }
}
