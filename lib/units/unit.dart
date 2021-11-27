import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';

import '../heeve_game.dart';
import '../highlight.dart';
import '../ordered_map_component.dart';
import '../projectile.dart';
import 'life_bar.dart';
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
  double currentHp;
  final int speed;

  Block? target;
  Block? reservedBlock;
  late final OrderedMapComponent map;

  Unit? attacking;
  late final Timer shootingTimer;

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
  })  : currentHp = hp.toDouble(),
        super(
          current: const UnitAnimationState(
            animation: AnimationState.idle,
            direction: DirectionState.upLeft,
          ),
          position: position,
          size: size,
          anchor: anchor ?? Anchor.bottomCenter,
          priority: priority ?? 2,
        ) {
    shootingTimer = Timer(1, repeat: true, onTick: shoot);
  }

  String get moveAsset;
  String get idleAsset;
  String get dieAsset => idleAsset;
  String get attackAsset => idleAsset;

  /// The exact point within the sprite where bullets should be shot/hit.
  Vector2 get bulletPosition => position - Vector2(0, height / 2);

  bool get isDead => currentHp <= 0;

  String _formatDirectionState(DirectionState state) =>
      state.toString().split('.')[1];

  String _asset(String path) => 'sprites/$path';

  Block get block => map.getBlock(position);

  Highlight get highlight => children.first as Highlight;

  bool get shouldRenderLifeBar => selected || currentHp < hp;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    map = gameRef.map;
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
  void render(Canvas canvas) {
    super.render(canvas);

    if (shouldRenderLifeBar) {
      final dimensions = Vector2(size.x, 8);
      final p = Vector2(0, -6);
      LifeBar.render(canvas, p, dimensions, currentHp / hp);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    highlight.position = map.getBlockRenderPosition(block) - topLeftPosition;

    final target = this.target;
    final attacking = this.attacking;
    if (target != null) {
      final targetBlockPosition = map.getBlockCenterPosition(target);
      final direction = targetBlockPosition - position;
      final step = speed * dt;

      final angle = direction.angleToSigned(Vector2(1, 0));
      current = UnitAnimationState.withDirection(
        AnimationState.move,
        angle,
      );

      if (direction.length < step) {
        position = targetBlockPosition;
        this.target = null;
        current = current?.copyWithState(AnimationState.idle);
      } else {
        direction.scaleTo(step);
        position += direction;
      }
    } else if (attacking != null) {
      if (attacking.isDead) {
        this.attacking = null;
      } else {
        final direction = attacking.position - position;
        final angle = direction.angleToSigned(Vector2(1, 0));
        current = UnitAnimationState.withDirection(
          AnimationState.attack,
          angle,
        );
      }
    }

    shootingTimer.update(dt);
  }

  bool containsBlock(Block block) => this.block == block;

  void shoot() {
    final enemy = attacking;
    if (enemy == null) {
      return;
    }
    gameRef.add(
      Projectile(
        speed: 100.0,
        damage: 2.5,
        src: bulletPosition,
        target: enemy,
      ),
    );
  }

  void takeDamage(double damage) {
    currentHp -= damage;
    if (isDead) {
      gameRef.map.removeUnit(this);
    }
  }

  void attack(Unit enemy) {
    attacking = enemy;
  }

  bool moveToBlock(final Block block) {
    attacking = null; // stop attacking
    final occupiedBlocks = map.occupiedBlocks;
    var width = 1;
    var height = 1;
    final x = block.x;
    final y = block.y;
    Block? nextBlock = block;

    for (;;) {
      if (map.validBlock(nextBlock)) {
        target = nextBlock;
        occupiedBlocks.remove(reservedBlock);
        occupiedBlocks.add(nextBlock!);
        reservedBlock = nextBlock;
        return true;
      }
      final topLeft = Block(x - width, y - height);
      final bottomRight = Block(x + width, y + height);
      final topRight = Block(bottomRight.x, topLeft.y);
      final bottomLeft = Block(topLeft.x, bottomRight.y);
      final blocks = _blocksBetween(topLeft, topRight)
        ..addAll(_blocksBetween(topRight, bottomRight))
        ..addAll(_blocksBetween(bottomRight, bottomLeft))
        ..addAll(_blocksBetween(bottomLeft, topLeft));
      nextBlock = blocks.firstWhereOrNull(map.validBlock);
      width++;
      height++;
    }
  }

  Set<Block> _blocksBetween(Block a, Block b) {
    final blocks = <Block>{};
    final minX = min(a.x, b.x);
    final maxX = max(a.x, b.x);
    final minY = min(a.y, b.y);
    final maxY = max(a.y, b.y);
    for (var x = minX; x <= maxX; x++) {
      for (var y = minY; y <= maxY; y++) {
        blocks.add(Block(x, y));
      }
    }
    return blocks;
  }

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
