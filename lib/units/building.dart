import 'package:flame/components.dart';

import '../heeve_game.dart';
import '../ordered_map_component.dart';

abstract class Building extends SpriteComponent with HasGameRef<HeeveGame> {
  final int cost;
  final int hp;
  Block get block => gameRef.map.getBlock(position);
  bool get isActive => parent is OrderedMapComponent;

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
