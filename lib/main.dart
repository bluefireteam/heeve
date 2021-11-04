import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'heeve_game.dart';

void main() {
  final gameWidget = GameWidget(game: HeeveGame());
  runApp(gameWidget);
}
