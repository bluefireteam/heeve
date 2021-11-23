import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heeve/building_button.dart';
import 'package:heeve/units/insects/butterfly.dart';

import 'heeve_game.dart';

class SideBar extends RectangleComponent with HasGameRef<HeeveGame> {
  @override
  bool isHud = true;

  @override
  int get priority => 200;

  static const double _width = 200;
  late final TextComponent currencyComponent;
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
    paint = Paint()..color = Colors.blueGrey;
    add(
      IsometricTileMapComponent(
        gameRef.tileset,
        gameRef.matrix,
        tileHeight: 8,
        destTileSize: Vector2(10, 10),
        position: Vector2(size.x / 2 + 10, 20),
      ),
    );

    final textRenderer = TextPaint(
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 16.0,
        shadows: [
          Shadow(color: Colors.red, offset: Offset(1, 1), blurRadius: 2),
          Shadow(color: Colors.yellow, offset: Offset(2, 2), blurRadius: 4),
        ],
      ),
    );

    await add(
      currencyComponent = TextComponent(
        text: '0',
        textRenderer: textRenderer,
        position: Vector2(_width / 2, 120),
        anchor: Anchor.center,
      )..add(
          currencyIndicator = Butterfly(
            position: Vector2(-12, 10),
            playing: false,
            loop: false,
          ),
        ),
    );
    add(
      ButtonComponent('green_buttons.png', position: Vector2(15, 150)),
    );
    add(
      ButtonComponent('red_buttons.png', position: Vector2(15, 210)),
    );

    gameRef.currencyNotifier.addListener(
      () {
        currencyComponent.text = gameRef.currencyNotifier.value.toString();
        if (!currencyIndicator.playing) {
          currencyIndicator.animation?.reset();
          currencyIndicator.playing = true;
        }
      },
    );
  }
}
