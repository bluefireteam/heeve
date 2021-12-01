import 'package:flame/components.dart';

import '../building.dart';

class Spaceship extends Building {
  static const int spaceshipHp = 1000;

  Spaceship({
    Vector2? position,
  }) : super(
          hp: spaceshipHp,
          position: position,
          size: Vector2(12, 15),
          anchor: Anchor.center,
        );

  @override
  String get idleAsset => 'human-spaceship.png';
}
