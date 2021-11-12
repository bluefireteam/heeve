import 'package:equatable/equatable.dart';

enum AnimationState {
  idle,
  moving,
  attack,
  defending,
  dying,
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

  @override
  List<Object?> get props => [animation, direction];
}
