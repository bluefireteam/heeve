import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'units/insects/butterfly.dart';

class CurrencyComponent extends TextComponent {
  late final SpriteAnimationComponent currencyIndicator;
  static const double _defaultFontSize = 16;
  static const double iconWidth = 20;
  final double fontSize;

  CurrencyComponent({
    int? value,
    Vector2? position,
    this.fontSize = _defaultFontSize,
  }) : super(
          text: value?.toString() ?? '0',
          position: position,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    textRenderer = TextPaint(
      style: TextStyle(
        color: Colors.white70,
        fontSize: fontSize,
        shadows: const [
          Shadow(color: Colors.red, offset: Offset(1, 1), blurRadius: 2),
          Shadow(color: Colors.yellow, offset: Offset(2, 2), blurRadius: 4),
        ],
      ),
    );
    final scale = fontSize / _defaultFontSize;
    currencyIndicator = Butterfly(
      position: Vector2(-12 * scale, 9 * scale),
      size: Vector2.all(iconWidth),
      playing: false,
      loop: false,
    );
    currencyIndicator.size.scale(fontSize / _defaultFontSize);
    add(currencyIndicator);
    currencyIndicator.animation?.onComplete = () {
      currencyIndicator.animation?.reset();
      currencyIndicator.playing = false;
    };
  }
}
