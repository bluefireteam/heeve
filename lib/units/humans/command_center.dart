import 'package:flame/components.dart';

import '../building.dart';

class CommandCenter extends Building {
  static const int commandCenterHp = 1000;

  CommandCenter({
      required Block block,
    Vector2? size,
    int? priority,
  }) : super(
          hp: commandCenterHp,
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
