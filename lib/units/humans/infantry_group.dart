import 'dart:collection';
import 'dart:math';

import 'package:flame/components.dart';

import '../../heeve_game.dart';
import '../unit.dart';

class InfantryGroup extends Component with HasGameRef<HeeveGame> {
  static final Random _rng = Random();
  final List<Unit> units;
  double timeSinceUpdate = 0;
  Block? groupTarget;
  Vector2? groupTargetPosition;
  late final int updateRate;
  final int abortRate = 100;

  InfantryGroup(this.units) {
    updateRate = 5 + _rng.nextInt(10);
  }

  bool closeToTarget() {
    return units.any((u) {
      return (groupTargetPosition?.distanceToSquared(units.first.position) ??
              0) <
          1000;
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    timeSinceUpdate += dt;
    if (timeSinceUpdate > abortRate ||
        (timeSinceUpdate > updateRate && (units.isEmpty || closeToTarget()))) {
      if (units.isEmpty) {
        if (groupTarget != null) {
          gameRef.map.occupiedBlocks.remove(groupTarget!);
        }
        removeFromParent();
        return;
      }
      gameRef.map.killBlock(groupTarget);
      groupTarget = gameRef.map.randomEdgeBlock();
      groupTargetPosition = gameRef.map.getBlockCenterPosition(groupTarget!);
      gameRef.map.occupiedBlocks.add(groupTarget!);
      Queue<Block>? commonPath;
      units.forEach((u) {
        if (u.isDead) {
          units.remove(u);
        } else if (commonPath == null) {
          commonPath = u.moveToBlock(groupTarget!);
        } else {
          u.moveToBlock(groupTarget!, withPath: commonPath);
        }
      });
      timeSinceUpdate = 0;
    }
  }
}
