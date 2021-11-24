import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';

import '../heeve_game.dart';
import '../highlight.dart';
import 'unit_animation_state.dart';

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

  Block? target;

  bool _selected = false;
  bool get selected => _selected;
  set selected(bool selected) {
    _selected = selected;
    highlight.visible = selected;
  }

  Unit({
    required this.hp,
    required this.speed,
    Vector2? position,
    Vector2? size,
    int? priority,
    Anchor? anchor,
  }) : super(
          current: const UnitAnimationState(
            animation: AnimationState.idle,
            direction: DirectionState.upLeft,
          ),
          position: position,
          size: size,
          anchor: anchor,
          priority: priority ?? 2,
        );

  String get moveAsset;
  String get idleAsset;
  String get dieAsset => idleAsset;
  String get attackAsset => idleAsset;

  String _formatDirectionState(DirectionState state) =>
      state.toString().split('.')[1];

  String _asset(String path) => 'sprites/$path';

  Block get block => gameRef.map.getBlock(position);

  Highlight get highlight => children.first as Highlight;

  @override
  void renderTree(Canvas canvas) {
    canvas.save();
    canvas.transform(transformMatrix.storage);

    children.forEach((c) => c.renderTree(canvas));
    render(canvas);

    // Any debug rendering should be rendered on top of everything
    if (debugMode) {
      renderDebugMode(canvas);
    }

    canvas.restore();
  }

  @override
  void update(double dt) {
    super.update(dt);

    highlight.position =
        gameRef.map.getBlockRenderPosition(block) - topLeftPosition;

    if (target != null) {
      final targetBlockPosition = gameRef.map.getBlockCenterPosition(target!);
      final direction = targetBlockPosition - position;
      final step = speed * dt;

      final angle = direction.angleToSigned(Vector2(1, 0));
      current = UnitAnimationState.withDirection(
        AnimationState.move,
        angle,
      );

      if (direction.length < step) {
        position = targetBlockPosition;
        target = null;
        current = current?.copyWithState(AnimationState.idle);
      } else {
        direction.scaleTo(step);
        position += direction;
      }
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animations = {};

    Future<void> createAnimationState(
      String asset,
      AnimationState state,
    ) async {
      final atlas = await gameRef.loadFireAtlas(_asset(asset));

      DirectionState.values.forEach((directionState) {
        animations![UnitAnimationState(
          animation: state,
          direction: directionState,
        )] = atlas.getAnimation(_formatDirectionState(directionState));
      });
    }

    await createAnimationState(idleAsset, AnimationState.idle);
    await createAnimationState(moveAsset, AnimationState.move);
    await createAnimationState(attackAsset, AnimationState.attack);
    await createAnimationState(dieAsset, AnimationState.die);

    await add(Highlight());
  }

  bool containsBlock(Block block) => this.block == block;

  bool intersectsBlock(Block start, Block end) {
    final block = this.block;
    final minX = min(start.x, end.x);
    final maxX = max(start.x, end.x);
    final minY = min(start.y, end.y);
    final maxY = max(start.y, end.y);
    return (block.x >= minX && block.x <= maxX) &&
        (block.y >= minY && block.y <= maxY);
  }
}
