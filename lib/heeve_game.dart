import 'package:dartlin/dartlin.dart';
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
        TapDetector,
        SecondaryTapDetector,
        PanDetector,
        KeyboardEvents,
        HasCollidables {
  late final SpriteSheet tileset;
  late final IsometricTileMapComponent map;
  late final Selector selector;

  static const movementBoundaries = 20;
  static const cameraMovementSpeed = 150.0;

  Vector2? movingCamera;
  List<Unit> selectedUnits = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.speed = 5000;
    camera.snapTo(Vector2(-250, -200));
    camera.viewport = FixedResolutionViewport(Vector2(800, 600));

    tileset = SpriteSheet(
      image: await images.load('tileset.png'),
      srcSize: Vector2.all(32.0),
    );
    final matrix = MapGenerator.generateMap();
    add(map = IsometricTileMapComponent(tileset, matrix, tileHeight: 8));

    add(
      Infantry(
        position: map.getBlockCenterPosition(const Block(0, 0)),
      ),
    );
    add(
      Infantry(
        position: map.getBlockCenterPosition(const Block(3, 8)),
      ),
    );

    add(selector = Selector());
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
    unselectAll();

    final pos = details.eventPosition.game;
    final block = map.getBlock(pos);

    children
        .whereType<Unit>()
        .where((unit) => unit.containsBlock(block))
        .forEach(select);
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
  void onPanStart(DragStartInfo info) {
    selector.selectionStart = info.eventPosition.game;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    selector.selectionStart ??= info.eventPosition.game;
    selector.selectionEnd = info.eventPosition.game;
  }

  @override
  void onPanEnd(DragEndInfo info) {
    unselectAll();

    final start = selector.selectionStart?.let(map.getBlock);
    final end = selector.selectionEnd?.let(map.getBlock);
    if (start != null && end != null) {
      children
          .whereType<Unit>()
          .where((unit) => unit.intersectsBlock(start, end))
          .forEach(select);
    }

    onPanCancel();
  }

  @override
  void onPanCancel() {
    selector.selectionStart = null;
    selector.selectionEnd = null;
  }

  void unselectAll() {
    selectedUnits.forEach((unit) => unit.selected = false);
    selectedUnits.clear();
  }

  void select(Unit unit) {
    selectedUnits.add(unit);
    unit.selected = true;
  }

  @override
  void onMouseMove(PointerHoverInfo details) {
    final mousePosition = details.eventPosition.global;
    final windowSize = camera.viewport.canvasSize!;
    movingCamera = null;
    if (mousePosition.x <= movementBoundaries) {
      movingCamera = Vector2(-1, 0);
    } else if (mousePosition.y <= movementBoundaries) {
      movingCamera = Vector2(0, -1);
    } else if (mousePosition.x >= windowSize.x - movementBoundaries) {
      movingCamera = Vector2(1, 0);
    } else if (mousePosition.y >= windowSize.y - movementBoundaries) {
      movingCamera = Vector2(0, 1);
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
