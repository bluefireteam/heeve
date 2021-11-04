import 'package:flame/components.dart';

enum AnimationState {
  idle,
  moving,
  attack,
  defending,
  dying,
}

/// A unit is anything that can be attacked and has different animations.
/// Example of units could be different types of insects, humans, building and
/// even things in the environment that should be possible to destroy, like
/// trees could be a [Unit].
///
/// All positions are anchored in the center.
class Unit extends SpriteAnimationGroupComponent<AnimationState>
    with HasHitboxes, Collidable {
  final int hp;
  final int speed;

  Unit({
    required this.hp,
    required this.speed,
    Vector2? position,
    Vector2? size,
    int? priority,
  }) : super(
          current: AnimationState.idle,
          position: position,
          size: size,
          anchor: Anchor.center,
          priority: priority,
        );
}
