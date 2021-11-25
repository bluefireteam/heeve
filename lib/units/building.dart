import 'package:flame/components.dart';

abstract class Building extends SpriteComponent with HasGameRef {
  final int cost;
  final int hp;

  Building({
    required this.hp,
    required this.cost,
    Vector2? position,
    Vector2? size,
    int? priority,
  }) : super(
          size: size,
          priority: priority,
          position: position,
          anchor: Anchor.center,
        );
}
