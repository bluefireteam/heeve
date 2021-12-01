import 'package:flame/components.dart';

import '../unit.dart';

class Infantry extends Unit {
  static const int infantryHp = 50;
  static const int infantrySpeed = 50;

  @override
  final bool movable = false;

  Infantry({
    Vector2? position,
  }) : super(
          position: position,
          hp: infantryHp,
          speed: infantrySpeed,
          size: Vector2(50, 50),
        );

  @override
  String get moveAsset => 'humans/infantry.fa';

  @override
  String get idleAsset => 'humans/infantry-idle.fa';

  @override
  String get attackAsset => 'humans/infantry-attack.fa';

  @override
  String get dieAsset => 'humans/infantry-die.fa';
}
