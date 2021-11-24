import 'dart:math';

import 'package:equatable/equatable.dart';

enum AnimationState {
  idle,
  move,
  attack,
  defend,
  die,
}

enum DirectionState {
  upLeft,
  upRight,
  downLeft,
  downRight,
}

class UnitAnimationState extends Equatable {
  final AnimationState animation;
  final DirectionState direction;

  const UnitAnimationState({
    required this.animation,
    required this.direction,
  });

  UnitAnimationState copyWithState(AnimationState animation) {
    return UnitAnimationState(animation: animation, direction: direction);
  }

  static UnitAnimationState withDirection(
    AnimationState animationState,
    double angle,
  ) {
    if (angle > 0 && angle < pi / 2) {
      return UnitAnimationState(
        animation: animationState,
        direction: DirectionState.upRight,
      );
    } else if (angle >= pi / 2 && angle < pi) {
      return UnitAnimationState(
        animation: animationState,
        direction: DirectionState.upLeft,
      );
    } else if (angle <= 0 && angle > -pi / 2) {
      return UnitAnimationState(
        animation: animationState,
        direction: DirectionState.downRight,
      );
    } else {
      return UnitAnimationState(
        animation: animationState,
        direction: DirectionState.downLeft,
      );
    }
  }

  @override
  List<Object?> get props => [animation, direction];
}
