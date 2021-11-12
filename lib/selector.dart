import 'package:flame/components.dart';

import 'heeve_game.dart';

class Selector extends SpriteComponent with HasGameRef<HeeveGame> {
  Block? block;

  Selector(Sprite sprite) : super(sprite: sprite, size: sprite.srcSize);

  @override
  void update(double dt) {
    super.update(dt);

    final block = this.block;
    if (block != null) {
      position = gameRef.map.getBlockPosition(block);
    }
  }

  @override
  int get priority => 1;
}
