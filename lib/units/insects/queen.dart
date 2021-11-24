import 'package:flame/components.dart';

import '../unit.dart';

class Queen extends Unit {
  static const int queenHp = 1000;
  static const int queenSpeed = 1000;

  Queen({
    required Vector2 position,
    Vector2? size,
    int? priority,
  }) : super(
          position: position,
          hp: queenHp,
          speed: queenSpeed,
          size: size,
          priority: priority,
        );

  @override
  String get moveAsset => '';
  @override
  String get idleAsset => '';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Sub classes should set up animation groups here
  }
}
