import 'package:flame/components.dart';
import 'package:heeve/units/building.dart';

class Nursery extends Building {
  static const int nurseryHp = 1000;

  Nursery(
    Vector2? position,
    Vector2? size,
    int? priority,
  ) : super(
          hp: nurseryHp,
          position: position,
          size: size,
          priority: priority,
        );

  Future<void> onLoad() async {
    await super.onLoad();
    // Sub classes should set up animation groups here
  }
}
