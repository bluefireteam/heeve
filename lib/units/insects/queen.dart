import 'package:flame/components.dart';

import '../unit.dart';

class Queen extends Unit {
  static const int queenHp = 1000;
  static const int queenSpeed = 1000;

  Queen({
    required Block block,
    Vector2? size,
    int? priority,
  }) : super(
          hp: queenHp,
          speed: queenSpeed,
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
