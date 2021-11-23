import 'package:flame/components.dart';
import 'package:flame/input.dart';

import 'heeve_game.dart';

enum ButtonState {
  pressed,
  unpressed,
}

class ButtonComponent extends SpriteGroupComponent<ButtonState>
    with HasGameRef<HeeveGame> {
  final String filename;

  ButtonComponent(this.filename, {Vector2? position, Vector2? size})
      : super(position: position, size: size ?? Vector2(34, 12.5) * 5);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final pressedSprite = await gameRef.loadSprite(
      filename,
      srcPosition: Vector2(0, 12.5),
      srcSize: Vector2(34, 12.5),
    );
    final unpressedSprite = await gameRef.loadSprite(
      filename,
      srcSize: Vector2(34, 12.5),
    );

    sprites = {
      ButtonState.pressed: pressedSprite,
      ButtonState.unpressed: unpressedSprite,
    };

    current = ButtonState.unpressed;
  }

  @override
  void onMount() {
    super.onMount();
    gameRef.tappableButtons.add(this);
  }

  @override
  void onRemove() {
    super.onRemove();
    gameRef.tappableButtons.remove(this);
  }

  @override
  bool containsPoint(Vector2 point) {
    return toAbsoluteRect().contains(point.toOffset());
  }

  bool onTapDown() {
    current = ButtonState.pressed;
    return true;
  }

  bool onTapUp() {
    current = ButtonState.unpressed;
    return true;
  }

  bool onTapCancel() {
    current = ButtonState.unpressed;
    return true;
  }
}
