import 'package:flame/components.dart';

import '../../heeve_game.dart';
import '../unit.dart';

class InfantryGroup extends Component with HasGameRef<HeeveGame> {
  final List<Unit> units;
  double timeSinceUpdate = 0;
  Block? groupTarget;

  InfantryGroup(this.units);

  @override
  void update(double dt) {
    super.update(dt);
    timeSinceUpdate += dt;
    if (timeSinceUpdate > 10) {
      if (units.isEmpty) {
        if (groupTarget != null) {
          gameRef.map.occupiedBlocks.remove(groupTarget!);
        }
        removeFromParent();
        return;
      }
      gameRef.map.killBlock(groupTarget);
      groupTarget = gameRef.map.randomEdgeBlock();
      gameRef.map.occupiedBlocks.add(groupTarget!);
      units.forEach((u) {
        if (u.isDead) {
          units.remove(u);
        } else {
          u.moveToBlock(groupTarget!);
        }
      });
      timeSinceUpdate = 0;
    }
  }
}
