import 'package:flame/components.dart';

import '../unit.dart';

class Hog extends Unit {
  static const int hogHp = 50;
  static const int hogSpeed = 50;

  Hog({
    required Block block,
    Vector2? size,
    int? priority,
  }) : super(
          hp: hogHp,
          speed: hogSpeed,
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
