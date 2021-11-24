import 'package:flame/components.dart';

import '../unit.dart';

class Spitter extends Unit {
  static const int spitterHp = 25;
  static const int spitterSpeed = 25;

  Spitter({
    required Vector2 position,
    Vector2? size,
    int? priority,
  }) : super(
          position: position,
          hp: spitterHp,
          speed: spitterSpeed,
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
