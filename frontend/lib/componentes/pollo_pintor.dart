import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

// Dibuja la imagen original del pollo en una cuadrícula de pedacitos y mueve cada
// pedacito con el tiempo: la cabeza se mece, los brazos se mueven y todo el cuerpo
// se estira y aplasta. Solo usa drawImageRect, que funciona en cualquier dispositivo.
class PolloPintor extends CustomPainter {
  final ui.Image imagen;
  final Animation<double> reloj;

  PolloPintor(this.imagen, this.reloj) : super(repaint: reloj);

  static const int _n = 24;
  static const double _solape = 2.0;
  static final Paint _pincel = Paint()
    ..filterQuality = FilterQuality.medium
    ..isAntiAlias = true;
  static final Float64List _m = Float64List(16)
    ..[10] = 1
    ..[15] = 1;

  // Transición suave entre 0 y 1 (a y b pueden ir en cualquier orden).
  static double _suave(double a, double b, double x) {
    final t = ((x - a) / (b - a)).clamp(0.0, 1.0).toDouble();
    return t * t * (3 - 2 * t);
  }

  static Offset _girar(Offset p, double cx, double cy, double ang) {
    final dx = p.dx - cx;
    final dy = p.dy - cy;
    return Offset(
      cx + dx * math.cos(ang) - dy * math.sin(ang),
      cy + dx * math.sin(ang) + dy * math.cos(ang),
    );
  }

  // Recibe un punto de la imagen (u, v entre 0 y 1) y devuelve dónde se dibuja.
  static Offset _deformar(double u, double v, double t) {
    final fase = 2 * math.pi * t;
    final radio = 2 * math.sqrt((u - 0.5) * (u - 0.5) + (v - 0.5) * (v - 0.5));
    final borde = _suave(1.0, 0.86, radio);

    var p = Offset(u, v);

    final cabeza = (1 - _suave(0.40, 0.60, v)) *
        _suave(0.22, 0.38, u) *
        (1 - _suave(0.66, 0.82, u)) *
        borde;
    p = _girar(p, 0.5, 0.58, 0.06 * math.sin(2 * fase + 0.6) * cabeza);

    final banda = _suave(0.10, 0.26, v) * (1 - _suave(0.74, 0.90, v)) * borde;
    final izq = _suave(0.42, 0.20, u) * banda;
    final der = _suave(0.58, 0.80, u) * banda;
    p = _girar(p, 0.31, 0.66, 0.13 * math.sin(2 * fase) * izq);
    p = _girar(p, 0.69, 0.66, -0.13 * math.sin(2 * fase + 0.6 * math.pi) * der);

    // Estirar y aplastar: la imagen solo crece, así nunca deja huecos en el borde.
    final rebote = 0.5 + 0.5 * math.sin(4 * fase);
    final sx = 1 + 0.02 * (1 - rebote);
    final sy = 1 + 0.04 * rebote;
    final x = 0.5 + (p.dx - 0.5) * sx;
    final y = 0.97 + (p.dy - 0.97) * sy;

    // Ligero acercamiento para que el borde del círculo quede siempre cubierto.
    return Offset(0.5 + (x - 0.5) * 1.03, 0.5 + (y - 0.5) * 1.03);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final t = reloj.value;
    final tw = imagen.width / _n;
    final th = imagen.height / _n;

    final puntos = <Offset>[];
    for (var j = 0; j <= _n; j++) {
      for (var i = 0; i <= _n; i++) {
        final p = _deformar(i / _n, j / _n, t);
        puntos.add(Offset(p.dx * size.width, p.dy * size.height));
      }
    }

    canvas.clipPath(Path()..addOval(Offset.zero & size));

    for (var j = 0; j < _n; j++) {
      for (var i = 0; i < _n; i++) {
        final a = puntos[j * (_n + 1) + i];
        final b = puntos[j * (_n + 1) + i + 1];
        final c = puntos[(j + 1) * (_n + 1) + i];

        // Cada pedacito se estira y gira según sus esquinas ya deformadas.
        _m[0] = (b.dx - a.dx) / tw;
        _m[1] = (b.dy - a.dy) / tw;
        _m[4] = (c.dx - a.dx) / th;
        _m[5] = (c.dy - a.dy) / th;
        _m[12] = a.dx;
        _m[13] = a.dy;

        // Se agranda 2 px por los lados internos para que no se vean costuras.
        final l = i > 0 ? _solape : 0.0;
        final u = j > 0 ? _solape : 0.0;
        final r = i < _n - 1 ? _solape : 0.0;
        final d = j < _n - 1 ? _solape : 0.0;

        canvas.save();
        canvas.transform(_m);
        canvas.drawImageRect(
          imagen,
          Rect.fromLTRB(i * tw - l, j * th - u, (i + 1) * tw + r, (j + 1) * th + d),
          Rect.fromLTRB(-l, -u, tw + r, th + d),
          _pincel,
        );
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant PolloPintor oldDelegate) =>
      oldDelegate.imagen != imagen;
}