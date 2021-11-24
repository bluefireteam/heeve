import 'package:flame/components.dart';
import 'package:flame/input.dart';

import 'heeve_game.dart';

enum ButtonState {
  pressed,
  unpressed,
}

class BuildButton extends SpriteGroupComponent<ButtonState>
    with HasGameRef<HeeveGame> {
  final String filename;
  final PositionComponent Function() buildComponentFunction;

  static final Vector2 defaultSize = Vector2(34, 12.5) * 5;

  BuildButton(
    this.filename,
    this.buildComponentFunction, {
    Vector2? position,
    Vector2? size,
  }) : super(position: position, size: size ?? defaultSize);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    children.register<PositionComponent>();
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

    final buildComponent = buildComponentFunction()
      ..position = (BuildButton.defaultSize / 2)
      ..y -= 6
      ..anchor = Anchor.center;
    add(buildComponent);
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
    children.query<PositionComponent>().forEach((c) => c.position.y += 6);
    final buildComponent = buildComponentFunction();
    gameRef.clearBuildComponent();
    gameRef.buildComponent = buildComponent;
    gameRef.add(buildComponent);
    return true;
  }

  bool onTapUp() {
    current = ButtonState.unpressed;
    children.query<PositionComponent>().forEach((c) => c.position.y -= 6);
    return true;
  }

  bool onTapCancel() {
    return onTapUp();
  }
}
