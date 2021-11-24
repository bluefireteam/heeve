import 'package:flame/components.dart';

import '../building.dart';

class CommandCenter extends Building {
  static const int commandCenterHp = 1000;

  CommandCenter({
    required Vector2 position,
    Vector2? size,
    int? priority,
  }) : super(
          position: position,
          hp: commandCenterHp,
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
