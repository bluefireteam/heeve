import 'package:flame/components.dart';
import 'package:flame/input.dart';

import 'heeve_game.dart';

enum ButtonState {
  up,
  down,
}

class ButtonComponent extends SpriteGroupComponent<ButtonState>
    with ButtonMethods {
  /// Callback for what should happen when the button is pressed.
  void Function()? onPressed;

  ButtonComponent({
    required Sprite button,
    required Sprite buttonDown,
    this.onPressed,
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super(
          current: ButtonState.up,
          position: position,
          size: size ?? button.originalSize,
          scale: scale,
          angle: angle,
          anchor: anchor,
          priority: priority,
        ) {
    sprites = {
      ButtonState.up: button,
      ButtonState.down: buttonDown,
    };
  }

  @override
  bool onTapDown() {
    current = ButtonState.down;
    return false;
  }

  @override
  bool onTapUp() {
    current = ButtonState.down;
    onPressed?.call();
    return false;
  }

  @override
  bool onTapCancel() {
    onTapUp();
    return false;
  }
}
