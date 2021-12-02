import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';

enum ButtonState {
  up,
  down,
}

class ButtonComponent extends SpriteGroupComponent<ButtonState> {
  /// Callback for what should happen when the button is pressed.
  void Function()? onPressed;

  Sprite? button;
  Sprite? buttonDown;

  ButtonComponent({
    this.button,
    this.buttonDown,
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
          size: size ?? button?.originalSize,
          scale: scale,
          angle: angle,
          anchor: anchor,
          priority: priority,
        ) {
    children.register<PositionComponent>();
  }

  @override
  void onMount() {
    assert(
      button != null && buttonDown != null,
      'button and buttonDown has to be initialized',
    );
    sprites = {
      ButtonState.up: button!,
      ButtonState.down: buttonDown!,
    };
    super.onMount();
  }

  bool _isPressed = false;

  @mustCallSuper
  bool onTapDown() {
    current = ButtonState.down;
    children.query<PositionComponent>().forEach((c) => c.position.y += 6);
    _isPressed = true;
    return false;
  }

  @mustCallSuper
  bool onTapUp() {
    if (_isPressed) {
      onPressed?.call();
      onTapCancel();
    }
    return false;
  }

  @mustCallSuper
  bool onTapCancel() {
    if (_isPressed) {
      current = ButtonState.up;
      children.query<PositionComponent>().forEach((c) => c.position.y -= 6);
    }
    return false;
  }
}
