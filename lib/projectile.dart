import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/palette.dart';

import 'units/unit.dart';

class Projectile extends PositionComponent {
  static final _paint = Paint()
    ..color = BasicPalette.black.color
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  static const _length = 2.0;

  final double speed;
  final double damage;

  Unit target;

  Projectile({
    required this.speed,
    required this.damage,
    required Vector2 src,
    required this.target,
  }) : super(position: src);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final end = (target.bulletPosition - position)..scaleTo(_length);
    canvas.drawLine(Offset.zero, end.toOffset(), _paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (target.isDead || target.shouldRemove || target.parent == null) {
      removeFromParent();
      return;
    }

    final targetPosition = target.bulletPosition;
    final direction = targetPosition - position;
    final ds = speed * dt;

    angle = direction.angleToSigned(Vector2(1, 0));

    if (direction.length < ds) {
      target.takeDamage(damage);
      removeFromParent();
    } else {
      direction.scaleTo(ds);
      position += direction;
    }
  }
}
