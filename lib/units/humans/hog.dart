import 'package:flame/components.dart';

import '../unit.dart';

class Hog extends Unit {
  static const int hogHp = 50;
  static const int hogSpeed = 50;

  Hog({
    required Vector2 position,
    Vector2? size,
    int? priority,
  }) : super(
          position: position,
          hp: hogHp,
          speed: hogSpeed,
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
