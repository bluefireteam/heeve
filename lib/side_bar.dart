import 'package:flame/components.dart';
import 'package:flame/input.dart';

import 'building_button.dart';
import 'currency_component.dart';
import 'heeve_game.dart';
import 'units/humans/spaceship.dart';
import 'units/insects/butterfly.dart';

class SideBar extends NineTileBoxComponent with HasGameRef<HeeveGame> {
  @override
  bool isHud = true;

  @override
  int get priority => 5;

  static const double _width = 200;
  late final CurrencyComponent currencyComponent;
  late final Butterfly currencyIndicator;

  SideBar() : super(size: Vector2(_width, 0));

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    final canvasSize = gameRef.size;
    size.y = canvasSize.y;
    position.x = canvasSize.x - _width;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final nineTileBoxSprite = await gameRef.loadSprite('nine-box.png');
    nineTileBox = NineTileBox(
      nineTileBoxSprite,
      tileSize: 8,
      destTileSize: 18,
    );
    add(
      IsometricTileMapComponent(
        gameRef.tileset,
        gameRef.matrix,
        tileHeight: 8,
        destTileSize: Vector2(10, 10),
        position: Vector2(size.x / 2 + 10, 20),
      ),
    );

    await add(
      currencyComponent = CurrencyComponent(
        value: gameRef.currencyNotifier.value,
        position: Vector2(_width / 2, 120),
      ),
    );

    final firstButtonPosition = Vector2(15, 150);
    add(
      BuildingButton(
        'green_buttons.png',
        () => Spaceship(),
        position: firstButtonPosition,
      ),
    );
    add(
      BuildingButton(
        'red_buttons.png',
        () => Spaceship(),
        position:
            firstButtonPosition + Vector2(0, BuildingButton.defaultSize.y),
      ),
    );

    gameRef.currencyNotifier.addListener(
      () {
        currencyComponent.text = gameRef.currencyNotifier.value.toString();
        final currencyIndicator = currencyComponent.currencyIndicator;
        if (!currencyIndicator.playing) {
          currencyIndicator.animation?.reset();
          currencyIndicator.playing = true;
        }
      },
    );
  }
}
