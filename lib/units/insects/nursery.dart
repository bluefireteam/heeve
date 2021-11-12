import 'package:flame/components.dart';

import '../building.dart';

class Nursery extends Building {
  static const int nurseryHp = 1000;

  Nursery({
    required Block block,
    Vector2? size,
    int? priority,
  }) : super(
          hp: nurseryHp,
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
