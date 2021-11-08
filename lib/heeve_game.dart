import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';

import 'map_generator.dart';
import 'selector.dart';

class HeeveGame extends FlameGame
    with MouseMovementDetector, ScrollDetector, PanDetector, KeyboardEvents {
  late final IsometricTileMapComponent map;
  late final Selector selector;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.speed = 5000;
    camera.viewport = FixedResolutionViewport(Vector2(800, 600));

    final tileset = SpriteSheet(
      image: await images.load('tileset.png'),
      srcSize: Vector2.all(32.0),
    );
    final matrix = MapGenerator.generateMap();
    add(map = IsometricTileMapComponent(tileset, matrix));
    add(selector = Selector(tileset.getSprite(3, 3)));
  }

  @override
  void onMouseMove(PointerHoverInfo details) {
    final pos = details.eventPosition.game;
    final block = map.getBlock(pos);
    if (map.containsBlock(block)) {
      selector.block = block;
    }
  }

  @override
  void onScroll(PointerScrollInfo event) {
    final zooms = [0.25, 0.5, 1.0, 2.0, 4.0, 10.0];
    final idx =
        zooms.indexOf(camera.zoom) - event.scrollDelta.game.y.sign.toInt();
    camera.zoom = zooms[idx % zooms.length];
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    camera.translateBy(info.delta.global * -1);
    camera.snap();
  }
}
