import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Guarda el estado de la foto del producto: la foto elegida y cómo la acomodó el admin.
// El formulario lo crea y el selector de foto lo usa (así el formulario no se llena de variables).
class ControladorFoto {
  final GlobalKey capturaKey = GlobalKey(); // marca el recuadro que se recorta al guardar
  final TransformationController encuadre = TransformationController();
  File? imagen; // foto nueva elegida (null = ninguna, se conserva la actual)

  // true si el admin movió la foto o le hizo zoom
  bool get encuadreModificado => encuadre.value != Matrix4.identity();

  // Archivo que se sube: el recorte tal como quedó en el recuadro si se acomodó la foto,
  // o la foto elegida tal cual (null = no cambiar la foto actual)
  Future<File?> archivoParaSubir({required bool hayFoto}) async {
    if (hayFoto && encuadreModificado) return _capturarEncuadre();
    return imagen;
  }

  Future<File> _capturarEncuadre() async {
    final limite =
        capturaKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final ui.Image captura = await limite.toImage(pixelRatio: 3.0);
    final bytes = await captura.toByteData(format: ui.ImageByteFormat.png);
    final archivo = File(
      '${Directory.systemTemp.path}/producto_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await archivo.writeAsBytes(bytes!.buffer.asUint8List());
    return archivo;
  }

  void dispose() => encuadre.dispose();
}
