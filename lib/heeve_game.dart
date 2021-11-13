import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';

import 'map_generator.dart';
import 'selector.dart';
import 'units/humans/infantry.dart';
import 'units/unit.dart';

class HeeveGame extends FlameGame
    with
        MouseMovementDetector,
        ScrollDetector,
        PanDetector,
        TapDetector,
        SecondaryTapDetector,
        KeyboardEvents,
        HasCollidables {
  late final IsometricTileMapComponent map;
  late final Selector selector;

  static const movementBoundaries = 10;
  static const cameraMovementSpeed = 150.0;

  Vector2? movingCamera;
  List<Unit> selectedUnits = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.speed = 5000;
    camera.snapTo(Vector2(-250, -200));
    camera.viewport = FixedResolutionViewport(Vector2(800, 600));

    final tileset = SpriteSheet(
      image: await images.load('tileset.png'),
      srcSize: Vector2.all(32.0),
    );
    final matrix = MapGenerator.generateMap();
    add(map = IsometricTileMapComponent(tileset, matrix));
    add(selector = Selector(tileset.getSprite(3, 3)));

    final infantry = Infantry(block: Block(0, 0));
    add(infantry);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (movingCamera != null) {
      camera.translateBy(movingCamera! * cameraMovementSpeed * dt);
      camera.snap();
    }
  }

  @override
  void onTapUp(TapUpInfo details) {
    final pos = details.eventPosition.game;
    final block = map.getBlock(pos);

    selectedUnits.forEach((unit) {
      unit.selected = false;
    });

    final selectedUnit = children.whereType<Unit>().where(
          (child) => child.block.x == block.x && child.block.y == block.y,
        );

    if (selectedUnit.isNotEmpty) {
      selectedUnits.addAll(selectedUnit.toList());
      selectedUnit.forEach((unit) {
        unit.selected = true;
      });
    }
  }

  @override
  void onSecondaryTapUp(TapUpInfo details) {
    final pos = details.eventPosition.game;
    final block = map.getBlock(pos);
    selectedUnits.forEach((unit) {
      unit.target = block;
    });
  }

  @override
  void onMouseMove(PointerHoverInfo details) {
    final mousePosition = details.eventPosition.global;
    movingCamera = null;
    if (mousePosition.x <= movementBoundaries) {
      movingCamera = Vector2(-1, 0);
    } else if (mousePosition.y <= movementBoundaries) {
      movingCamera = Vector2(0, -1);
    } else if (mousePosition.x >=
        camera.viewport.effectiveSize.x - movementBoundaries) {
      movingCamera = Vector2(1, 0);
    } else if (mousePosition.y >=
        camera.viewport.effectiveSize.y - movementBoundaries) {
      movingCamera = Vector2(0, 1);
    } else {
      final pos = details.eventPosition.game;
      final block = map.getBlock(pos);
      if (map.containsBlock(block)) {
        selector.block = block;
      }
    }
  }

  @override
  void onScroll(PointerScrollInfo event) {
    final zooms = [0.25, 0.5, 1.0, 2.0, 4.0, 10.0];
    final idx =
        zooms.indexOf(camera.zoom) - event.scrollDelta.game.y.sign.toInt();
    camera.zoom = zooms[idx % zooms.length];
  }
}
