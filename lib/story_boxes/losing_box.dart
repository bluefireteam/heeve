import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import '../button_component.dart';
import '../units/insects/worker.dart';
import '../units/unit_animation_state.dart';
import 'story_box.dart';

class LosingBox extends StoryBox {
  final storyStyle = TextPaint(
    style: const TextStyle(
      color: Colors.black38,
      fontSize: 12.0,
      fontFamily: 'Sigmar',
    ),
  );

  LosingBox() : super(size: Vector2(380, 400));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final logo = Worker(position: Vector2(size.x / 2, 60));
    await add(logo);
    logo.current = const UnitAnimationState(
      animation: AnimationState.move,
      direction: DirectionState.downRight,
    );
    final headerStyle = TextPaint(
      style: const TextStyle(
        color: Color.fromRGBO(47, 108, 79, 1.0), //476c4f
        fontSize: 40.0,
        fontFamily: 'Sigmar',
        shadows: [
          Shadow(offset: Offset(2, 2), blurRadius: 2),
          Shadow(color: Colors.green, offset: Offset(2, 2), blurRadius: 4),
        ],
      ),
    );

    final pixelStyle = TextPaint(
      style: const TextStyle(
        color: Colors.grey, //476c4f
        fontSize: 14.0,
        fontFamily: 'PressStart2P',
      ),
    );

    add(
      TextComponent(
        text: 'Heeve',
        textRenderer: headerStyle,
        position: Vector2(width / 2, 90),
        anchor: Anchor.center,
      ),
    );

    final instructionsText = TextBoxComponent(
      text: 'The terrible terrible humans have ruined the ecosystem of your '
          'planet (removed 100 blocks). (The next time that they arrive, you '
          'will be prepared with more buildings and more types of insectiods.)',
      textRenderer: storyStyle,
      boxConfig: TextBoxConfig(timePerChar: 0.08, maxWidth: 280),
      position: Vector2(size.x / 2 + 20, 170),
      anchor: Anchor.center,
    );

    const filename = 'red_buttons.png';
    final pressedSprite = await gameRef.loadSprite(
      filename,
      srcPosition: Vector2(0, 12.5),
      srcSize: Vector2(34, 12.5),
    );
    final unpressedSprite = await gameRef.loadSprite(
      filename,
      srcSize: Vector2(34, 12.5),
    );
    final startText = TextComponent(
      text: 'Close',
      textRenderer: pixelStyle,
      position: Vector2(100, 15),
      anchor: Anchor.center,
      priority: 1,
    );
    final startButton = ButtonComponent(
      button: unpressedSprite,
      buttonDown: pressedSprite,
      position: Vector2(width / 2, 345),
      size: Vector2(200, 40),
      anchor: Anchor.center,
      onPressed: removeFromParent,
    )..add(startText);
    gameRef.tappableButtons.add(startButton);
    add(instructionsText);
    add(startButton);
  }
}
