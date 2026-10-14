import 'dart:io';
import 'package:flutter/material.dart';
import 'controlador_foto.dart';

// Recuadro de la foto: vacío (tocar o arrastrar) o con la foto, que se puede acomodar
class RecuadroFoto extends StatelessWidget {
  static const Color _color = Colors.orangeAccent;

  final ControladorFoto controlador;
  final String? imagenUrl; // foto actual del producto (modo edición)
  final bool habilitado;
  final bool arrastrando; // hay un archivo encima del recuadro
  final VoidCallback onElegir;

  const RecuadroFoto({
    super.key,
    required this.controlador,
    required this.imagenUrl,
    required this.habilitado,
    required this.arrastrando,
    required this.onElegir,
  });

  Widget _boton(IconData icono, VoidCallback? onTap) {
    return Material(
      color: Colors.black54,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icono, size: 18, color: Colors.white),
        ),
      ),
    );
  }

  Widget _vacio() {
    return GestureDetector(
      onTap: habilitado ? onElegir : null,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: arrastrando ? Colors.orange.shade50 : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: arrastrando ? _color : Colors.grey.shade400, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              arrastrando ? Icons.file_download : Icons.add_a_photo,
              size: 48,
              color: _color,
            ),
            const SizedBox(height: 8),
            Text(
              arrastrando ? 'Suelta la imagen aquí' : 'Toca o arrastra aquí la foto del producto',
              style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _conFoto(File? imagen) {
    final Widget foto = imagen != null
        ? Image.file(imagen, fit: BoxFit.contain)
        : Image.network(
            imagenUrl!,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stack) =>
                const Icon(Icons.broken_image, size: 40, color: Colors.grey),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _color, width: arrastrando ? 4 : 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Solo esta parte se recorta al guardar (sin los botones)
                RepaintBoundary(
                  key: controlador.capturaKey,
                  child: Container(
                    color: Colors.white,
                    child: InteractiveViewer(
                      transformationController: controlador.encuadre,
                      panEnabled: habilitado,
                      scaleEnabled: habilitado,
                      minScale: 0.5,
                      maxScale: 4,
                      // Margen infinito: la foto se queda donde el admin la suelte
                      boundaryMargin: const EdgeInsets.all(double.infinity),
                      child: SizedBox.expand(child: foto),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      _boton(
                        Icons.center_focus_strong,
                        habilitado ? () => controlador.encuadre.value = Matrix4.identity() : null,
                      ),
                      const SizedBox(width: 6),
                      _boton(Icons.photo_camera, habilitado ? onElegir : null),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Arrastra la foto para acomodarla · pellizca para hacer zoom',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final File? imagen = controlador.imagen;
    final bool hayFoto = imagen != null || (imagenUrl != null && imagenUrl!.isNotEmpty);
    return hayFoto ? _conFoto(imagen) : _vacio();
  }
}