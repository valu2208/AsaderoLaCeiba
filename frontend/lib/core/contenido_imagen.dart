import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

// Busca el rectángulo de la foto que realmente tiene comida, ignorando márgenes
// blancos o transparentes. Ignora el 2 % de píxeles más externos de cada lado,
// para que una línea fina de borde o un poco de ruido no engañen al detector.
Future<Rect> detectarContenido(ui.Image img) async {
  final w = img.width;
  final h = img.height;
  final completo = Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble());

  try {
    final datos = await img.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (datos == null) return completo;

    final paso = math.max(1, math.min(w, h) ~/ 250);
    final cols = (w + paso - 1) ~/ paso;
    final filas = (h + paso - 1) ~/ paso;
    final porColumna = List<int>.filled(cols, 0);
    final porFila = List<int>.filled(filas, 0);
    var total = 0;

    for (var fy = 0; fy < filas; fy++) {
      for (var fx = 0; fx < cols; fx++) {
        final i = ((fy * paso) * w + fx * paso) * 4;
        final transparente = datos.getUint8(i + 3) < 20;
        final blanco = datos.getUint8(i) >= 235 &&
            datos.getUint8(i + 1) >= 235 &&
            datos.getUint8(i + 2) >= 235;
        if (!transparente && !blanco) {
          porColumna[fx]++;
          porFila[fy]++;
          total++;
        }
      }
    }

    // Casi todo blanco: no hay nada que recortar con seguridad.
    if (total < cols * filas * 0.01) return completo;

    final limite = total * 0.02;

    int desde(List<int> conteo) {
      var acumulado = 0;
      for (var k = 0; k < conteo.length; k++) {
        acumulado += conteo[k];
        if (acumulado >= limite) return k;
      }
      return 0;
    }

    int hasta(List<int> conteo) {
      var acumulado = 0;
      for (var k = conteo.length - 1; k >= 0; k--) {
        acumulado += conteo[k];
        if (acumulado >= limite) return k;
      }
      return conteo.length - 1;
    }

    final x0 = desde(porColumna) * paso.toDouble();
    final x1 = (hasta(porColumna) + 1) * paso.toDouble();
    final y0 = desde(porFila) * paso.toDouble();
    final y1 = (hasta(porFila) + 1) * paso.toDouble();

    // Un 4 % de margen para no pegarse al borde de la comida.
    final mx = (x1 - x0) * 0.04;
    final my = (y1 - y0) * 0.04;
    final rect = Rect.fromLTRB(
      math.max(0, x0 - mx),
      math.max(0, y0 - my),
      math.min(w.toDouble(), x1 + mx),
      math.min(h.toDouble(), y1 + my),
    );

    // Si recortó demasiado, algo salió raro: se usa la foto completa.
    if (rect.width < w * 0.3 || rect.height < h * 0.3) return completo;
    return rect;
  } catch (_) {
    return completo;
  }
}