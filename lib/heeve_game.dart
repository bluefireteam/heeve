import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';

class HeeveGame extends FlameGame with PanDetector {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.speed = 5000;
    camera.viewport = FixedResolutionViewport(Vector2(800, 600));
    final backgroundSprite = await loadSprite('background.jpg');
    add(SpriteComponent(sprite: backgroundSprite));
  }

  SelectionRectangle selection = SelectionRectangle();

  @override
  void onPanStart(DragStartInfo info) {
    selection.position = info.eventPosition.viewportOnly;
    selection.size.setZero();
    add(selection);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    //camera.moveTo(camera.position - info.delta.global);
    selection.size += info.delta.viewportOnly;
  }

  @override
  void onPanCancel() {
    remove(selection);
  }

  @override
  void onPanEnd(DragEndInfo _) {
    onPanCancel();
  }
}

class SelectionRectangle extends PositionComponent {
  @override
  bool isHud = true;

  final paint = BasicPalette.red.paint()..style = PaintingStyle.stroke;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), paint);
  }
}
