import 'package:flame/components.dart';
import 'package:flame/input.dart';

import '../heeve_game.dart';

class StoryBox extends NineTileBoxComponent with HasGameRef<HeeveGame> {
  @override
  bool isHud = true;

  @override
  int get priority => 6;

  StoryBox({Vector2? size})
      : super(size: size ?? Vector2(300, 400), anchor: Anchor.center);

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    final canvasSize = gameRef.size;
    position = canvasSize / 2;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final nineTileBoxSprite = await gameRef.loadSprite('nine-box.png');
    nineTileBox = NineTileBox(
      nineTileBoxSprite,
      tileSize: 8,
      destTileSize: 32,
    );
  }
}
