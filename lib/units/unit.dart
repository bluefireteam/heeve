import 'package:flame/components.dart';
import 'package:heeve/units/unit_animation_state.dart';

import '../heeve_game.dart';

/// A unit is anything that can be attacked and has different animations.
/// Example of units could be different types of insects, humans, building and
/// even things in the environment that should be possible to destroy, like
/// trees could be a [Unit].
///
/// All positions are anchored in the center.
class Unit extends SpriteAnimationGroupComponent<UnitAnimationState>
    with HasHitboxes, Collidable, HasGameRef<HeeveGame> {
  final int hp;
  final int speed;

  Unit({
    required this.hp,
    required this.speed,
    Vector2? position,
    Vector2? size,
    int? priority,
  }) : super(
          current: const UnitAnimationState(
            animation: AnimationState.idle,
            direction: DirectionState.up,
          ),
          position: position,
          size: size,
          anchor: Anchor.center,
          priority: priority,
        );
}
