import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import '../button_component.dart';
import '../units/insects/worker.dart';
import '../units/unit_animation_state.dart';
import 'intro_box.dart';
import 'story_box.dart';

// This is shown before the story so that we can play the audio meanwhile the
// user reads on the next box.
class StartBox extends StoryBox {
  StartBox() : super(size: Vector2(380, 220));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final logo = Worker(position: Vector2(size.x / 2, 70));
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
        position: Vector2(size.x / 2, 110),
        anchor: Anchor.center,
      ),
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
      text: 'Start',
      textRenderer: pixelStyle,
      position: Vector2(100, 15),
      anchor: Anchor.center,
      priority: 1,
    );
    final startButton = ButtonComponent(
      button: unpressedSprite,
      buttonDown: pressedSprite,
      position: Vector2(size.x / 2, 165),
      size: Vector2(200, 40),
      anchor: Anchor.center,
      onPressed: () {
        removeFromParent();
        gameRef.add(IntroBox());
        FlameAudio.bgm.play('intro.mp3');
      },
    )..add(startText);
    gameRef.tappableButtons.add(startButton);
    add(startButton);
  }
}
