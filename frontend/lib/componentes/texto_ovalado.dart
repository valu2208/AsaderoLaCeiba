import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

// Escribe "ASADERO" y "LA CEIBA" letra por letra, en arco alrededor del logo.
// progreso va de 0 a 1: primero se escribe la línea de arriba y luego la de abajo.
// Cada letra se revela de izquierda a derecha, como si se escribiera con un lápiz
// mágico, que deja una chispa en el punto donde va escribiendo.
class TextoOvaladoPainter extends CustomPainter {
  final Animation<double> progreso;

  TextoOvaladoPainter(this.progreso) : super(repaint: progreso);

  static const _arriba = 'ASADERO';
  static const _abajo = 'LA CEIBA';

  @override
  void paint(Canvas canvas, Size size) {
    final ovalo = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width - 10,
      height: size.height - 10,
    );

    const estilo = TextStyle(
      color: AppColors.goldSand,
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
    );

    final total = (_arriba.length + _abajo.length).toDouble();
    final avance = progreso.value * total;

    dibujarTexto(canvas, _arriba, Path()..addArc(ovalo, math.pi, math.pi), estilo, avance);
    dibujarTexto(canvas, _abajo, Path()..addArc(ovalo, math.pi, -math.pi), estilo,
        avance - _arriba.length);
  }

  void dibujarTexto(Canvas canvas, String texto, Path camino, TextStyle estilo, double avance) {
    final metricas = camino.computeMetrics().toList();
    if (metricas.isEmpty) return;
    final metrica = metricas.first;

    final letras = texto.split('').map((letra) {
      return TextPainter(
        text: TextSpan(text: letra, style: estilo),
        textDirection: TextDirection.ltr,
      )..layout();
    }).toList();

    final ancho = letras.fold<double>(0, (total, l) => total + l.width);
    double distancia = (metrica.length - ancho) / 2;

    for (var i = 0; i < letras.length; i++) {
      final letra = letras[i];
      final aparece = (avance - i).clamp(0.0, 1.0).toDouble();
      final tangente = metrica.getTangentForOffset(
        (distancia + letra.width / 2).clamp(0.0, metrica.length).toDouble(),
      );

      if (tangente != null && aparece > 0) {
        canvas.save();
        canvas.translate(tangente.position.dx, tangente.position.dy);
        canvas.rotate(tangente.angle);

        // Revela la letra de izquierda a derecha.
        final x = -letra.width / 2 + letra.width * aparece;
        canvas.save();
        canvas.clipRect(Rect.fromLTRB(-letra.width, -letra.height, x, letra.height));
        letra.paint(canvas, Offset(-letra.width / 2, -letra.height / 2));
        canvas.restore();

        // Chispa del lápiz mientras escribe la letra.
        if (aparece < 1) {
          canvas.drawCircle(
            Offset(x, 0),
            7,
            Paint()..color = const Color(0xFFFFE27A),
          );
        }
        canvas.restore();
      }
      distancia += letra.width;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}