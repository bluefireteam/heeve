import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:ordered_set/ordered_set.dart';

import 'units/unit.dart';

class OrderedMapComponent extends IsometricTileMapComponent {
  final List<Block> occupiedBlocks = [];
  late final OrderedSet<PositionComponent> gridChildren;
  late final int maxX;
  late final int maxY;

  OrderedMapComponent(
    SpriteSheet tileset,
    List<List<int>> matrix, {
    double? tileHeight,
  }) : super(tileset, matrix, tileHeight: tileHeight) {
    maxX = matrix.length;
    maxY = matrix.first.length;
    final cornerPosition = getBlockRenderPosition(Block(maxX, maxY));
    int cornerDistance(PositionComponent c) =>
        c.position.distanceToSquared(cornerPosition).floor();
    gridChildren = OrderedSet(
      (c1, c2) => cornerDistance(c2).compareTo(cornerDistance(c1)),
    );
    children.register<PositionComponent>();

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

  bool addOnBlock(PositionComponent component, Block block) {
    if (validBlock(block)) {
      gridChildren.add(component..position = getBlockCenterPosition(block));
      if (component is Unit) {
        component.reservedBlock = block;
      }
      occupiedBlocks.add(block);
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
}
