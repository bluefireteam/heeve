import 'dart:ui';

import 'package:flame/components.dart';

import 'heeve_game.dart';

class Highlight extends SpriteComponent with HasGameRef<HeeveGame> {
  bool visible = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = gameRef.tileset.getSprite(3, 3);
    size = sprite!.srcSize;
  }

  @override
  void render(Canvas c) {
    if (!visible) {
      return;
    }
    super.render(c);
  }
}
