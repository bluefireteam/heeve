import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/animation.dart';

import '../../has_block.dart';
import '../../heeve_game.dart';
import '../../ordered_map_component.dart';
import 'worker.dart';

class Butterfly extends SpriteAnimationComponent
    with HasGameRef<HeeveGame>, HasHitboxes, Collidable, HasBlock {
  static final _rng = Random();
  bool _isPickedUp = false;
  bool loop;

  @override
  OrderedMapComponent get map => gameRef.map;

  Butterfly({
    Vector2? position,
    Vector2? size,
    this.loop = true,
    bool? playing,
  }) : super(
          position: position,
          size: size ?? Vector2.all(20),
          anchor: Anchor.center,
          playing: playing,
          priority: 3,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    animation = await gameRef.loadSpriteAnimation(
      'butterfly.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1 + _rng.nextDouble() / 10,
        textureSize: Vector2.all(32),
        loop: loop,
      ),
    );
    addHitbox(HitboxCircle());
    collidableType = CollidableType.passive;
  }

  @override
  void onCollision(_, Component other) {
    if (!_isPickedUp && other is Worker) {
      _isPickedUp = true;
      gameRef.currencyNotifier.value++;
      add(
        RotateEffect(
          angle: 3,
          duration: 1.8,
          curve: Curves.elasticOut,
        ),
      );
      add(
        SizeEffect(
          size: Vector2.zero(),
          duration: 1.9,
          curve: Curves.elasticOut,
          onComplete: removeFromParent,
        ),
      );
    }
  }
}
