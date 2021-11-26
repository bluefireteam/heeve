import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:ordered_set/ordered_set.dart';

class OrderedMapComponent extends IsometricTileMapComponent {
  late final Block corner;
  final List<Block> occupiedBlocks = [];
  late final OrderedSet<PositionComponent> renderOrder;

  OrderedMapComponent(
    SpriteSheet tileset,
    List<List<int>> matrix, {
    double? tileHeight,
  }) : super(tileset, matrix, tileHeight: tileHeight) {
    corner = Block(matrix.length, matrix.first.length);
    final cornerPosition = getBlockRenderPosition(corner);
    int cornerDistance(PositionComponent c) =>
        c.position.distanceToSquared(cornerPosition).floor();
    renderOrder = OrderedSet(
        (c1, c2) => cornerDistance(c2).compareTo(cornerDistance(c1)));
    children.register<PositionComponent>();
  }

  @override
  void update(double dt) {
    super.update(dt);
    //TODO(spydon): This will be very heavy, but maybe it doesn't matter for now
    renderOrder.rebalanceAll();
  }

  @override
  void renderTree(Canvas canvas) {
    canvas.save();
    canvas.transform(transformMatrix.storage);

    render(canvas);
    renderOrder.forEach((c) => c.renderTree(canvas));

    // Any debug rendering should be rendered on top of everything
    if (debugMode) {
      renderDebugMode(canvas);
    }

    canvas.restore();
  }

  bool addOnBlock(PositionComponent component, Block block) {
    if (!occupiedBlocks.contains(block)) {
      renderOrder.add(component..position = getBlockCenterPosition(block));
      add(component);
      occupiedBlocks.add(block);
      return true;
    }
    return false;
  }
}
