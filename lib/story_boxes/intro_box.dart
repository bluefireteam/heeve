import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import '../button_component.dart';
import '../units/insects/worker.dart';
import '../units/unit_animation_state.dart';
import 'instructions_box.dart';
import 'story_box.dart';

class IntroBox extends StoryBox {
  final storyStyle = TextPaint(
    style: const TextStyle(
      color: Colors.black38,
      fontSize: 12.0,
      fontFamily: 'Sigmar',
    ),
  );
  late final TextBoxComponent _firstPartTextComponent;
  bool _secondPartAdded = false;
  bool _doneSizing = true;

  IntroBox() : super(size: Vector2(380, 220));

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

    _firstPartTextComponent = TextBoxComponent(
      text: 'The most terrible parasites in the universe have arrived on your '
          'planet. They have already destroyed several planets by their '
          'overconsumption.',
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
      text: 'Go get them!',
      textRenderer: pixelStyle,
      position: Vector2(100, 15),
      anchor: Anchor.center,
      priority: 1,
    );
    final startButton = ButtonComponent(
      button: unpressedSprite,
      buttonDown: pressedSprite,
      position: Vector2(width / 2, 165),
      size: Vector2(200, 40),
      anchor: Anchor.center,
      onPressed: () {
        if (_doneSizing) {
          gameRef.add(InstructionsBox());
          removeFromParent();
        }
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
            onComplete: () => add(_firstPartTextComponent),
          ),
        ),
    );
    add(
      SizeEffect(
        size: Vector2(380, 400),
        duration: 0.5,
        onComplete: () => _doneSizing = true,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_secondPartAdded && _firstPartTextComponent.finished) {
      _secondPartAdded = true;
      add(
        TextBoxComponent(
          text:
              'Apparently they are called humans, and you have to stop them before '
              'they turn your planet into an uninhabitable void.',
          textRenderer: storyStyle,
          boxConfig: TextBoxConfig(timePerChar: 0.08, maxWidth: 280),
          position: Vector2(size.x / 2 + 20, 270),
          anchor: Anchor.center,
        ),
      );
    }
  }
}
