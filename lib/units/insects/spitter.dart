import 'package:flame/components.dart';

import '../unit.dart';

class Spitter extends Unit {
  static const int spitterHp = 25;
  static const int spitterSpeed = 25;

  Spitter({
    required Block block,
    Vector2? size,
    int? priority,
  }) : super(
          hp: spitterHp,
          speed: spitterSpeed,
          size: size,
          priority: priority,
                    block: block,

        );

  @override
  String get movingAsset => '';
  @override
  String get idleAsset => '';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Sub classes should set up animation groups here
  }
}
