import 'package:flame/components.dart';
import 'package:flame/input.dart';

import 'building_button.dart';
import 'currency_component.dart';
import 'heeve_game.dart';
import 'units/insects/butterfly.dart';
import 'units/insects/hatchery.dart';

class SideBar extends NineTileBoxComponent with HasGameRef<HeeveGame> {
  @override
  bool isHud = true;

  @override
  int get priority => 5;

  static const double barWidth = 200;
  late final CurrencyComponent currencyComponent;
  late final Butterfly currencyIndicator;

  SideBar() : super(size: Vector2(barWidth, 0));

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    final canvasSize = gameRef.size;
    size.y = canvasSize.y;
    position.x = canvasSize.x - barWidth;
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
        destTileSize: Vector2(8, 8),
        position: Vector2(size.x / 2, 30),
      ),
    );

    await add(
      currencyComponent = CurrencyComponent(
        value: gameRef.currencyNotifier.value,
        position: Vector2(barWidth / 2 + CurrencyComponent.iconWidth / 2, 140),
      ),
    );

    final firstButtonPosition = Vector2(15, 160);
    add(
      BuildingButton(
        'red_buttons.png',
        () => Hatchery(),
        position: firstButtonPosition,
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
