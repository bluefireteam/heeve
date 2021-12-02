import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:a_star_algorithm/a_star_algorithm.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';

import '../block_extension.dart';
import '../has_block.dart';
import '../heeve_game.dart';
import '../highlight.dart';
import '../offset_extension.dart';
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
    with HasGameRef<HeeveGame>, HasBlock {
  static Random rng = Random();
  final int hp;
  double currentHp;
  final int speed;
  final bool hasFireAtlas = true;

  Block? target;
  Block? reservedBlock;
  Queue<Block> path = Queue();

  @override
  OrderedMapComponent get map => gameRef.map;

  Unit? attackTarget;
  List<Unit> attackedBy = [];
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

  String get idleAsset;
  String get moveAsset => idleAsset;
  String get dieAsset => idleAsset;
  String get attackAsset => idleAsset;

  /// The exact point within the sprite where bullets should be shot/hit.
  Vector2 get bulletPosition => position - Vector2(0, height / 2);

  bool get isDead => currentHp <= 0;

  bool get selectable => !isDead;
  final bool movable = true;

  String _formatDirectionState(DirectionState state) =>
      state.toString().split('.')[1];

  String _asset(String path) => 'sprites/$path';

  late final Highlight highlight;

  bool get shouldRenderLifeBar => !isDead && (selected || currentHp < hp);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animations = {};

    if (!hasFireAtlas) {
      Future<void> createStaticState(String asset, AnimationState state) async {
        final sprite = await gameRef.loadSpriteAnimation(
          asset,
          SpriteAnimationData.sequenced(
            amount: 1,
            stepTime: 100000,
            textureSize: Vector2(96, 112),
          ),
        );

        DirectionState.values.forEach((directionState) {
          animations![UnitAnimationState(
            animation: state,
            direction: directionState,
          )] = sprite;
        });
      }

      await createStaticState(idleAsset, AnimationState.idle);
    } else {
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
    }

    await add(highlight = Highlight());
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
    if (isDead) {
      animation?.update(dt);
      if (animation?.done() != false) {
        gameRef.map.removeUnit(this);
      }
      return;
    }
    attackedBy.removeWhere((u) => u.isDead);

    highlight.position = map.getBlockRenderPosition(block) - topLeftPosition;

    final attackTarget = this.attackTarget;
    if (path.isNotEmpty) {
      final targetBlockPosition = map.getBlockCenterPosition(path.first);
      final direction = targetBlockPosition - position;
      final step = speed * dt;

      final angle = direction.angleToSigned(Vector2(1, 0));
      current = UnitAnimationState.withDirection(
        AnimationState.move,
        angle,
      );

      if (direction.length < step) {
        position = targetBlockPosition;
        path.removeFirst();
        if (path.isEmpty) {
          current = current?.copyWithState(AnimationState.idle);
        }
      } else {
        direction.scaleTo(step);
        position += direction;
      }
    } else if (attackTarget != null) {
      if (attackTarget.isDead || distance(attackTarget) > 100) {
        this.attackTarget = null;
        current = UnitAnimationState.withDirection(
          AnimationState.idle,
          angle,
        );
      } else {
        final direction = attackTarget.position - position;
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
    final enemy = attackTarget;
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
      gameRef.unselectUnit(this);
      current = UnitAnimationState(
        animation: AnimationState.die,
        direction: current?.direction ?? DirectionState.upLeft,
      );
      if (dieAsset == idleAsset) {
        add(
          SizeEffect(
            size: Vector2.zero(),
            duration: 1,
            onComplete: () => map.removeUnit(this),
          ),
        );
      }
      animation?.loop = false;
    }
  }

  void attack(Unit enemy) {
    if (enemy.distance(this) < 100) {
      attackTarget = enemy;
      path.clear();
      if (map.getBlockCenterPosition(block) != position) {
        moveToBlock(block);
      }
      enemy.attackedBy.add(this);
    } else {
      moveToBlock(enemy.block);
    }
  }

  Future<void> moveToBlock(final Block targetBlock) async {
    attackTarget = null; // stop attacking
    final occupiedBlocks = map.occupiedBlocks;
    occupiedBlocks.remove(reservedBlock);
    target = reservedBlock = map.findCloseValidBlock(targetBlock);
    occupiedBlocks.add(reservedBlock!);

    // TODO: Optimize so that not all units in a group have to re-run this
    //final currentBlock = block;
    //generatePath(
    //  currentBlock,
    //  target!,
    //  map.matrix,
    //  map.occupiedBlocks,
    //).then((path) => this.path = path);
    path
      ..clear()
      ..addFirst(target!);
  }

  Future<Queue<Block>> generatePath(
    Block startingBlock,
    Block target,
    List<List<int>> matrix,
    Set<Block> occupiedBlocks,
  ) async {
    final offsetPath = await Future(
      AStar(
        rows: map.maxX,
        columns: map.maxY,
        start: startingBlock.toOffset(),
        end: target.toOffset(),
        barriers: occupiedBlocks.map((b) => b.toOffset()).toList()
          ..removeWhere(
            (o) => o == target.toOffset() || o == startingBlock.toOffset(),
          ),
      ).findThePath,
    );
    final path = Queue<Block>();
    offsetPath.forEach((o) => path.addFirst(o.toBlock()));
    path.addLast(target);
    return path;
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
