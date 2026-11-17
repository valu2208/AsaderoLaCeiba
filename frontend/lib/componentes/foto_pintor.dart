import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

// Dibuja la parte útil de la foto llenando todo el espacio (como BoxFit.cover).
class FotoPintor extends CustomPainter {
  final ui.Image imagen;
  final Rect contenido;

  FotoPintor(this.imagen, this.contenido);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final escala = math.max(
      size.width / contenido.width,
      size.height / contenido.height,
    );
    final origen = Rect.fromCenter(
      center: contenido.center,
      width: size.width / escala,
      height: size.height / escala,
    );

    canvas.drawImageRect(
      imagen,
      origen,
      Offset.zero & size,
      Paint()..filterQuality = FilterQuality.medium,
    );
  }

  @override
  bool shouldRepaint(covariant FotoPintor viejo) =>
      viejo.imagen != imagen || viejo.contenido != contenido;
}