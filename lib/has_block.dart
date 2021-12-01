import 'package:flame/components.dart';

import 'ordered_map_component.dart';

mixin HasBlock on PositionComponent {
  late Block initialBlock;

  late OrderedMapComponent map;

  Block get block => parent == null ? initialBlock : map.getBlock(position);
}
