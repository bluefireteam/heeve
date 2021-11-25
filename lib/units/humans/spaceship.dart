import 'package:flame/components.dart';

import '../building.dart';

class Spaceship extends Building {
  static const int spaceshipHp = 1000;
  static const int spaceshipCost = 3;

  Spaceship({
    Vector2? position,
  }) : super(
          hp: spaceshipHp,
          cost: spaceshipCost,
          position: position,
          size: Vector2(40, 32),
          priority: 3,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('human-spaceship.png');
  }
}
