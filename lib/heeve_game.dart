import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

class HeeveGame extends FlameGame with PanDetector {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.speed = 5000;
    camera.viewport = FixedResolutionViewport(Vector2(800, 600));
    final backgroundSprite = await loadSprite('background.jpg');
    add(SpriteComponent(sprite: backgroundSprite));
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    camera.moveTo(camera.position - info.delta.global);
  }
}
