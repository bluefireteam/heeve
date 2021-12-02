import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import '../button_component.dart';
import '../side_bar.dart';
import '../units/insects/worker.dart';
import '../units/unit_animation_state.dart';
import 'story_box.dart';

class InstructionsBox extends StoryBox {
  final storyStyle = TextPaint(
    style: const TextStyle(
      color: Colors.black38,
      fontSize: 12.0,
      fontFamily: 'Sigmar',
    ),
  );

  InstructionsBox() : super(size: Vector2(380, 400));

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
      text: 'Select insectoids by dragging or left click on them, move and '
          'attack with right click. Gather butterflies (your food) by attacking '
          'the mines and kill the humans and their ships by right clicking on '
          'them. Build hatcheries for 10 butterflies, they will spawn more '
          'insectoids.',
      textRenderer: storyStyle,
      boxConfig: TextBoxConfig(timePerChar: 0.08, maxWidth: 280),
      position: Vector2(size.x / 2 + 20, 220),
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
      text: 'Go get them!',
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
      onPressed: () {
        startText.position.y += 6;
        gameRef.add(SideBar());
        gameRef.hasStarted = true;
        removeFromParent();
      },
    )..add(startText);
    gameRef.tappableButtons.add(startButton);
    add(instructionsText);
    add(startButton);
  }
}
