import 'package:flame/components.dart';
import 'package:heeve/units/unit_animation_state.dart';

import '../unit.dart';

class Infantry extends Unit {
  static const int infantryHp = 50;
  static const int infantrySpeed = 50;

  //static final Vector2 offset = Vector2(3, 5);


  Infantry({
    required Block block,
  }) : super(
          hp: infantryHp,
          speed: infantrySpeed,
          size: Vector2(50, 50),
          priority: 10,
          anchor: const Anchor(0.1, 0.6),
          block: block,
        );

  @override
  String get movingAsset => 'humans/foot-soldier.fa';
  @override
  String get idleAsset => 'humans/foot-soldier-idle.fa';
}
