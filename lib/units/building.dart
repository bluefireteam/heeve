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
    required this.cost,
    Vector2? position,
    Vector2? size,
    int? priority,
  }) : super(
          hp: hp,
          speed: 0,
          size: size,
          priority: priority,
          position: position,
          anchor: const Anchor(0.5, 0.75),
        );
}
