import 'dart:html';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'heeve_game.dart';

void main() {
  // Prevent default event handler
  document.onContextMenu.listen((event) => event.preventDefault());

  final gameWidget = GameWidget(game: HeeveGame());
  runApp(gameWidget);
}
