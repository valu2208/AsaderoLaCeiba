import 'dart:math';
import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

// Dibuja el fondo de la barra con una muesca curva sobre el ícono activo.
class FondoBarra extends CustomPainter {
  final double centro; // posición horizontal del centro de la muesca

  const FondoBarra({required this.centro});

  static const double _profundidad = 40;
  static const double _mitadAncho = 44;

  @override
  void paint(Canvas canvas, Size size) {
    // Lo que se ve dentro de la muesca: el rojo del degradado de arriba
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = AppColors.redPrayerFlag,
    );

    // Que la muesca no se salga por los lados de la pantalla
    final m = min(_mitadAncho, min(centro, size.width - centro));
    final curva = m * 0.6;

    final barra = Path()
      ..moveTo(0, 0)
      ..lineTo(centro - m, 0)
      ..cubicTo(
        centro - curva, 0,
        centro - curva, _profundidad,
        centro, _profundidad,
      )
      ..cubicTo(
        centro + curva, _profundidad,
        centro + curva, 0,
        centro + m, 0,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(barra, Paint()..color = AppColors.asphalt);
  }

  @override
  bool shouldRepaint(FondoBarra anterior) => anterior.centro != centro;
}