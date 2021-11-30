import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';

import 'button_component.dart';
import 'currency_component.dart';
import 'heeve_game.dart';
import 'units/building.dart';

class BuildingButton extends ButtonComponent with HasGameRef<HeeveGame> {
  final String filename;
  final Building Function() buildingComponentFunction;
  late final int cost;
  late final CurrencyComponent currencyComponent;

  static final Vector2 defaultSize = Vector2(34, 12.5) * 5;

  BuildingButton(
    this.filename,
    this.buildingComponentFunction, {
    Vector2? position,
    Vector2? size,
  }) : super(position: position, size: size ?? defaultSize);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    children.register<PositionComponent>();
    button = await gameRef.loadSprite(
      filename,
      srcSize: Vector2(34, 12.5),
    );
    buttonDown = await gameRef.loadSprite(
      filename,
      srcPosition: Vector2(0, 12.5),
      srcSize: Vector2(34, 12.5),
    );

    final buildingComponent = buildingComponentFunction()
      ..position = (BuildingButton.defaultSize / 2)
      ..size = Vector2.all(35)
      ..y -= 6
      ..anchor = Anchor.center;
    add(buildingComponent);

    cost = buildingComponent.cost;
    add(
      currencyComponent = CurrencyComponent(
        value: cost,
        position: size - Vector2(20, 30),
        fontSize: 10,
      ),
    );
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

  @override
  bool onTapDown() {
    super.onTapDown();
    if (gameRef.currencyNotifier.value >= cost) {
      final buildComponent = buildingComponentFunction();
      gameRef.clearBuildComponent();
      gameRef.buildingComponent = buildComponent;
      gameRef.add(buildComponent);
    } else {
      currencyComponent.add(
        ScaleEffect(
          scale: Vector2.all(1.5),
          duration: 1,
          isAlternating: true,
        ),
      );
    }
    return true;
  }
}
