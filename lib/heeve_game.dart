import 'package:dartlin/dartlin.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'button_component.dart';
import 'map_generator.dart';
import 'ordered_map_component.dart';
import 'selector.dart';
import 'side_bar.dart';
import 'story_boxes/losing_box.dart';
import 'story_boxes/start_box.dart';
import 'story_boxes/winning_box.dart';
import 'units/building.dart';
import 'units/humans/infantry.dart';
import 'units/humans/spaceship.dart';
import 'units/insects/butterfly.dart';
import 'units/insects/ore.dart';
import 'units/insects/worker.dart';
import 'units/unit.dart';

class HeeveGame extends FlameGame
    with
        MouseMovementDetector,
        TapDetector,
        SecondaryTapDetector,
        PanDetector,
        KeyboardEvents,
        HasCollidables {
  late final SpriteSheet tileset;
  late final OrderedMapComponent map;
  late final List<List<int>> matrix;
  late final Selector selector;
  Building? buildingComponent;

  static const movementBoundaries = 20;
  static const cameraMovementSpeed = 150.0;

  Vector2 cameraDirection = Vector2.zero();
  List<Unit> selectedUnits = [];
  // To circumvent not being able to add `HasTappables`
  final List<ButtonComponent> tappableButtons = [];

  final ValueNotifier<int> currencyNotifier = ValueNotifier<int>(0);

  bool hasStarted = false;
  bool hasShownEndBox = false;
  bool get hasWon {
    return hasStarted &&
        map.children.query<Spaceship>().isEmpty &&
        map.children.query<Infantry>().isEmpty;
  }

  bool get hasLost => map.killedBlocks >= 100;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await FlameAudio.audioCache.loadAll([
      'intro.mp3',
      'battle.mp3',
      'sci-fi.mp3',
    ]);
    //await Future<void>.delayed(const Duration(seconds: 3));

    camera.speed = 5000;
    camera.viewport = FixedResolutionViewport(Vector2(800, 600));

    add(StartBox());
    //add(SideBar());
    tileset = SpriteSheet(
      image: await images.load('tileset.png'),
      srcSize: Vector2.all(32.0),
    );
    matrix = MapGenerator.generateMap();

    await add(map = OrderedMapComponent(tileset, matrix, tileHeight: 8));
    centerMap();

    map.addOnBlock(Worker(), const Block(2, 2));
    List.generate(4, (_) => map.addOnBlock(Ore(), map.randomBlock()));
    List.generate(3, (_) => map.addOnBlock(Spaceship(), map.randomBlock()));
    final butterflyBlocks = List<Block>.generate(
      15,
      (i) => Block(i + i % 2, i + i % 3),
    );
    butterflyBlocks.forEach((block) => map.addOnBlock(Butterfly(), block));

    add(selector = Selector());
  }

  @override
  void update(double dt) {
    super.update(dt);
    tappableButtons.removeWhere((b) => b.parent == null);

    if (hasWon && !hasShownEndBox) {
      add(WinningBox());
      hasShownEndBox = true;
      return;
    } else if (hasLost && !hasShownEndBox) {
      add(LosingBox());
      hasShownEndBox = true;
      return;
    }

    if (!FlameAudio.bgm.isPlaying && hasStarted) {
      final songs = ['intro.mp3', 'battle.mp3', 'sci-fi.mp3']..shuffle();
      FlameAudio.bgm.play(songs.first);
    }

    camera.translateBy(cameraDirection * cameraMovementSpeed * dt);
    camera.snap();
  }

  void centerMap() {
    camera.snapTo(
      (map.position - size / 2 + canvasSize / 8)..x -= SideBar.barWidth * 0.5,
    );
  }

  @override
  void onTapDown(TapDownInfo details) {
    final building = buildingComponent;
    if (building != null) {
      final block = map.getBlock(details.eventPosition.game);
      if (!map.occupiedBlocks.contains(block)) {
        building.size.scale(2);
        map.addOnBlock(building, block);
        buildingComponent = null;
        currencyNotifier.value -= building.cost;
        building.changeParent(map);
      } else {
        building.add(
          RotateEffect(
            angle: 1,
            duration: 0.5,
            isAlternating: true,
          ),
        );
      }
    }

    tappableButtons
        .where((t) => t.containsPoint(details.eventPosition.viewportOnly))
        .forEach((t) => t.onTapDown());
  }

  @override
  void onTapUp(TapUpInfo details) {
    tappableButtons
        .where((t) => t.containsPoint(details.eventPosition.viewportOnly))
        .forEach((t) => t.onTapUp());

    unselectAll();

    final position = details.eventPosition.game;
    final block = map.getBlock(position);

    map.gridChildren
        .whereType<Unit>()
        .where((unit) => unit.containsBlock(block))
        .forEach(select);
  }

  @override
  void onTapCancel() {
    tappableButtons.forEach((t) => t.onTapCancel());
  }

  void clearBuildComponent() {
    buildingComponent?.removeFromParent();
    buildingComponent = null;
  }

  @override
  void onSecondaryTapUp(TapUpInfo details) {
    final position = details.eventPosition.game;
    final block = map.getBlock(position);
    final enemy = map.gridChildren
        .whereType<Unit>()
        .firstOrNull((it) => it.block == block);
    if (enemy != null) {
      selectedUnits.whereType<Worker>().forEach((worker) {
        if (worker != enemy) {
          worker.attack(enemy);
        }
      });
    } else {
      selectedUnits.forEach((unit) {
        if (unit.movable) {
          unit.moveToBlock(block);
        }
      });
    }
    clearBuildComponent();
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

    final start = selector.selectionStart;
    final end = selector.selectionEnd;
    if (start != null && end != null) {
      final selectionRect = Rect.fromPoints(start.toOffset(), end.toOffset());
      map.children
          .whereType<Unit>()
          .where((unit) => unit.selectable)
          .where((unit) {
        final p = map.getBlockCenterPosition(unit.block);
        return selectionRect.contains(p.toOffset());
      }).forEach(select);
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

  void unselectUnit(Unit unit) {
    selectedUnits.remove(unit);
    unit.selected = false;
  }

  void select(Unit unit) {
    selectedUnits.add(unit);
    unit.selected = true;
  }

  @override
  void onMouseMove(PointerHoverInfo details) {
    final mousePosition = details.eventPosition.global;
    final windowSize = camera.viewport.canvasSize!;
    if (mousePosition.x <= movementBoundaries) {
      cameraDirection.setValues(-1, 0);
    } else if (mousePosition.y <= movementBoundaries) {
      cameraDirection.setValues(0, -1);
    } else if (mousePosition.x >= windowSize.x - movementBoundaries) {
      cameraDirection.setValues(1, 0);
    } else if (mousePosition.y >= windowSize.y - movementBoundaries) {
      cameraDirection.setValues(0, 1);
    } else {
      cameraDirection.setValues(0, 0);
    }

    final building = buildingComponent;
    if (building != null) {
      building.position = details.eventPosition.game;
      map.getBlock(building.topLeftPosition);
    }
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isDown = event is RawKeyDownEvent;
    final w = LogicalKeyboardKey.keyW;
    final a = LogicalKeyboardKey.keyA;
    final s = LogicalKeyboardKey.keyS;
    final d = LogicalKeyboardKey.keyD;
    final e = LogicalKeyboardKey.keyE;
    final q = LogicalKeyboardKey.keyQ;
    final z = LogicalKeyboardKey.keyZ;
    final move = cameraDirection;

    if (event.logicalKey == e && isDown) {
      camera.zoom *= 2;
    } else if (event.logicalKey == q && isDown) {
      camera.zoom /= 2;
    } else if (event.logicalKey == z && isDown) {
      centerMap();
    }

    if (event.logicalKey == w) {
      if (isDown) {
        move.y = -1;
      } else if (keysPressed.contains(s)) {
        move.y = 1;
      } else {
        move.y = 0;
      }
    } else if (event.logicalKey == s) {
      if (isDown) {
        move.y = 1;
      } else if (keysPressed.contains(w)) {
        move.y = -1;
      } else {
        move.y = 0;
      }
    } else if (event.logicalKey == a) {
      if (isDown) {
        move.x = -1;
      } else if (keysPressed.contains(d)) {
        move.x = 1;
      } else {
        move.x = 0;
      }
    } else if (event.logicalKey == d) {
      if (isDown) {
        move.x = 1;
      } else if (keysPressed.contains(a)) {
        move.x = -1;
      } else {
        move.x = 0;
      }
    }

    return KeyEventResult.handled;
  }
}
