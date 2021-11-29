import 'dart:html';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'heeve_game.dart';

void main() {
  // Prevent default event handler
  document.onContextMenu.listen((event) => event.preventDefault());

  final gameWidget = GameWidget(
    game: HeeveGame(),
    loadingBuilder: (_) => GameWidget(game: LoadingScreen()),
  );
  runApp(gameWidget);
}

class LoadingScreen extends FlameGame {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final logo = await loadSprite('flame.png');
    add(
      SpriteComponent(sprite: logo, position: size / 2, anchor: Anchor.center)
        ..add(
          OpacityEffect.fadeOut(
            duration: 2,
            isAlternating: true,
            isInfinite: true,
          ),
        ),
    );

    final pixelStyle = TextPaint(
      style: const TextStyle(
        color: Colors.grey, //476c4f
        fontSize: 20.0,
        fontFamily: 'PressStart2P',
      ),
    );

    add(
      TextComponent(
        text: 'Made with Flame',
        textRenderer: pixelStyle,
        position: (size / 2)
          ..y += 140
          ..x += 13,
        anchor: Anchor.center,
        priority: 1,
      ),
    );
  }
}
