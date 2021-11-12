import 'package:flame/components.dart';

import '../building.dart';

class CommandCenter extends Building {
  static const int commandCenterHp = 1000;

  CommandCenter(
    Vector2? position,
    Vector2? size,
    int? priority,
  ) : super(
          hp: commandCenterHp,
          position: position,
          size: size,
          priority: priority,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Sub classes should set up animation groups here
  }
}
