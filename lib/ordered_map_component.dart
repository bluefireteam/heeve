import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:ordered_set/ordered_set.dart';

import 'has_block.dart';
import 'units/humans/infantry.dart';
import 'units/humans/spaceship.dart';
import 'units/insects/butterfly.dart';
import 'units/insects/worker.dart';
import 'units/unit.dart';

class OrderedMapComponent extends IsometricTileMapComponent {
  static Random rng = Random();
  final Set<Block> occupiedBlocks = {};
  late final OrderedSet<HasBlock> gridChildren;
  late final int maxX;
  late final int maxY;
  int killedBlocks = 0;

  OrderedMapComponent(
    SpriteSheet tileset,
    List<List<int>> matrix, {
    double? tileHeight,
  }) : super(tileset, matrix, tileHeight: tileHeight);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    children.register<Worker>();
    children.register<Butterfly>();
    children.register<Infantry>();
    children.register<Spaceship>();
    maxX = matrix.length;
    maxY = matrix.first.length;
    int blockPriority(HasBlock c) => c.block.x + c.block.y;
    gridChildren = OrderedSet(
      (c1, c2) => blockPriority(c1).compareTo(blockPriority(c2)),
    );

    // Add empty tiles to occupiedBlocks so that units can't stand on them
    for (var x = 0; x < matrix.length; x++) {
      for (var y = 0; y < matrix.first.length; y++) {
        if (matrix[x][y] == 4) {
          occupiedBlocks.add(Block(y, x));
        }
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    //TODO(spydon): This will be very heavy, but maybe it doesn't matter for now
    gridChildren.rebalanceAll();
  }

  @override
  void renderTree(Canvas canvas) {
    canvas.save();
    canvas.transform(transformMatrix.storage);

    render(canvas);
    gridChildren.forEach((c) => c.renderTree(canvas));

    // Any debug rendering should be rendered on top of everything
    if (debugMode) {
      renderDebugMode(canvas);
    }

    canvas.restore();
  }

  bool addOnBlock(HasBlock component, Block block) {
    if (validBlock(block)) {
      component.initialBlock = block;
      gridChildren.add(component..position = getBlockCenterPosition(block));
      if (component is Unit) {
        component.reservedBlock = block;
        occupiedBlocks.add(block);
      }
      add(component);
      return true;
    }
    return false;
  }

  void removeUnit(Unit unit) {
    occupiedBlocks.remove(unit.block);
    gridChildren.remove(unit);
    unit.removeFromParent();
  }

  bool validBlock(Block? block) {
    return block != null &&
        !occupiedBlocks.contains(block) &&
        containsBlock(block);
  }

  bool nonEmptyBlock(Block? block) {
    return block != null &&
        containsBlock(block) &&
        matrix[block.y][block.x] != 4;
  }

  void killBlock(Block? block) {
    if (block == null) {
      return;
    }
    killedBlocks++;
    matrix[block.y][block.x] = 4;
    occupiedBlocks.add(block);
  }

  Block randomEdgeBlock() {
    assert(
      occupiedBlocks.length < matrix.length * matrix.first.length,
      'All blocks are occupied',
    );
    final isVariableX = rng.nextBool();
    final isMin = rng.nextBool();
    final startBlock = Block(
      isVariableX
          ? rng.nextInt(matrix.first.length)
          : (isMin ? 0 : matrix.first.length),
      !isVariableX ? rng.nextInt(matrix.length) : (isMin ? 0 : matrix.length),
    );
    var block = nonEmptyBlock(startBlock) ? startBlock : null;
    var radius = 1;

    // This checks one edge that could be excluded
    while (block == null) {
      final blocksToCheck = [
        Block(startBlock.x, startBlock.y + radius),
        Block(startBlock.x + radius, startBlock.y),
        Block(startBlock.x, startBlock.y - radius),
        Block(startBlock.x - radius, startBlock.y),
      ]..shuffle(rng);
      block = blocksToCheck.firstWhereOrNull(nonEmptyBlock);
      radius++;
    }
    return block;
  }

  Block randomBlock() {
    assert(
      occupiedBlocks.length < matrix.length * matrix.first.length,
      'All blocks are occupied',
    );

    for (;;) {
      final block = Block(rng.nextInt(maxX), rng.nextInt(maxY));
      if (validBlock(block)) {
        return block;
      }
    }
  }

  Block findCloseValidBlock(Block startingBlock, {bool random = false}) {
    Block? nextBlock = startingBlock;
    final x = startingBlock.x;
    final y = startingBlock.y;
    var width = 1;
    var height = 1;

    while (!validBlock(nextBlock)) {
      final topLeft = Block(x - width, y - height);
      final bottomRight = Block(x + width, y + height);
      final topRight = Block(bottomRight.x, topLeft.y);
      final bottomLeft = Block(topLeft.x, bottomRight.y);
      final blocks = (_blocksBetween(bottomRight, bottomLeft)
            ..addAll(_blocksBetween(bottomLeft, topLeft))
            ..addAll(_blocksBetween(topRight, bottomRight))
            ..addAll(_blocksBetween(topLeft, topRight)))
          .toList(growable: false);
      if (random) {
        blocks.shuffle(rng);
      }
      nextBlock = blocks.firstWhereOrNull(validBlock);
      width++;
      height++;
    }
    return nextBlock!;
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
}
