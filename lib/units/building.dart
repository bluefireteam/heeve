import 'package:flame/components.dart';

import '../ordered_map_component.dart';
import 'unit.dart';

abstract class Building extends Unit {
  final int cost;
  bool get isActive => parent is OrderedMapComponent;

  @override
  final bool selectable = false;

  @override
  final bool movable = false;

  Building({
    required int hp,
    this.cost = 0,
    Vector2? position,
    Vector2? size,
    int? priority,
    Anchor? anchor,
  }) : super(
          hp: hp,
          speed: 0,
          size: size,
          priority: priority,
          position: position,
          anchor: anchor,
        );
}
