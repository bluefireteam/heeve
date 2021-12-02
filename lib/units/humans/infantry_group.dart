import 'dart:math';

import 'package:flame/components.dart';

import '../../heeve_game.dart';
import '../unit.dart';

class InfantryGroup extends Component with HasGameRef<HeeveGame> {
  static final Random _rng = Random();
  final List<Unit> units = [];
  double timeSinceUpdate = 0;
  Block? groupTarget;
  Vector2? groupTargetPosition;
  late final int updateRate;
  final int abortRate = 40;

  InfantryGroup() {
    updateRate = 5 + _rng.nextInt(10);
  }

  bool closeToTarget() {
    return units.any((u) {
      return (groupTargetPosition?.distanceToSquared(u.position) ?? 0) < 1000;
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    timeSinceUpdate += dt;
    final shouldAbort = timeSinceUpdate > abortRate;
    if (shouldAbort || (timeSinceUpdate > updateRate && closeToTarget())) {
      if (!shouldAbort) {
        gameRef.map.killBlock(groupTarget);
      }
      groupTarget = gameRef.map.randomEdgeBlock();
      groupTargetPosition = gameRef.map.getBlockCenterPosition(groupTarget!);
      gameRef.map.occupiedBlocks.add(groupTarget!);
      units.removeWhere((u) => u.isDead);
      units.forEach((u) => u.moveToBlock(groupTarget!));
      timeSinceUpdate = 0;
    }
  }
}
