import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import '../button_component.dart';
import '../side_bar.dart';
import '../units/insects/worker.dart';
import '../units/unit_animation_state.dart';
import 'story_box.dart';

class IntroBox extends StoryBox {
  IntroBox() : super(size: Vector2(300, 220));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final logo = Worker(position: Vector2(size.x / 2, 90));
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
      text: 'Go get them!',
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
        startText.position.y += 6;
        gameRef.add(SideBar());
        removeFromParent();
      },
    )..add(startText);
    gameRef.tappableButtons.add(startButton);
    add(
      startButton
        ..add(
          MoveEffect(
            path: [Vector2(0, 180)],
            duration: 0.7,
            isRelative: true,
            onComplete: startStory,
          ),
        ),
    );
    add(SizeEffect(size: Vector2(300, 400), duration: 0.5));
  }

  void startStory() {
    final storyStyle = TextPaint(
      style: const TextStyle(
        color: Colors.black38,
        fontSize: 12.0,
        fontFamily: 'Sigmar',
      ),
    );

    add(
      TextBoxComponent(
        text:
            'Here Erick is going to write about who the insectoids are fighting and '
            'why, and he will also write other good things probably, who knows?',
        textRenderer: storyStyle,
        boxConfig: TextBoxConfig(timePerChar: 0.081, maxWidth: 250),
        position: Vector2(size.x / 2 + 20, 190),
        anchor: Anchor.center,
      ),
    );
  }
}
