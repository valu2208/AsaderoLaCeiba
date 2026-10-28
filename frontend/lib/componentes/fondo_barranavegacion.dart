
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

class FondoBarra extends CustomPainter {
  final double centro;

  const FondoBarra({required this.centro});

  static const double radio = 24;
  static const double _holgura = 4;
  static const double _mitadAncho = 60;
  static const double _angulo = 0.2;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = AppColors.redPrayerFlag,
    );

    final m = min(
      _mitadAncho,
      min(centro, size.width - centro),
    );

    final cy = size.height / 2;
    final r = radio + _holgura;
    final px = r * cos(_angulo);
    final py = cy + r * sin(_angulo);
    final cx2 = 14 * sin(_angulo);
    final cy2 = 14 * cos(_angulo);

    final barra = Path()
      ..moveTo(0, 0)
      ..lineTo(centro - m, 0)
      ..cubicTo(
        centro - m + 18,
        0,
        centro - px - cx2,
        py - cy2,
        centro - px,
        py,
      )
      ..arcTo(
        Rect.fromCircle(
          center: Offset(centro, cy),
          radius: r,
        ),
        pi - _angulo,
        -(pi - 2 * _angulo),
        false,
      )
      ..cubicTo(
        centro + px + cx2,
        py - cy2,
        centro + m - 18,
        0,
        centro + m,
        0,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      barra,
      Paint()..color = AppColors.asphalt,
    );
  }

  @override
  bool shouldRepaint(FondoBarra anterior) {
    return anterior.centro != centro;
  }
}
