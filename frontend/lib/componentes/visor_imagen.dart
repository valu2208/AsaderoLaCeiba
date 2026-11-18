import 'package:flutter/material.dart';

// Abre una foto a pantalla completa: zoom con dos dedos y se cierra
// con la X o tocando el fondo. Sirve para todos los roles.
void verImagenGrande(BuildContext context, Widget imagen) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => Dialog.fullscreen(
      backgroundColor: Colors.black87,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(dialogContext),
            child: SizedBox.expand(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 5,
                child: Center(child: imagen),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(dialogContext),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// Foto del menú, comprobante o QR: puede ser una URL (http) o un asset.
void verFoto(BuildContext context, String ruta) {
  if (ruta.isEmpty) return;

  const error = Center(
    child: Icon(Icons.broken_image, color: Colors.white54, size: 64),
  );

  final Widget imagen = ruta.startsWith('http')
      ? Image.network(
          ruta,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,
          loadingBuilder: (context, hijo, progreso) => progreso == null
              ? hijo
              : const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
          errorBuilder: (context, e, s) => error,
        )
      : Image.asset(
          ruta,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,
          errorBuilder: (context, e, s) => error,
        );

  verImagenGrande(context, imagen);
}

// Envuelve cualquier foto: al tocarla se abre ampliada.
class FotoAmpliable extends StatelessWidget {
  final String ruta;
  final Widget child;

  const FotoAmpliable({super.key, required this.ruta, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => verFoto(context, ruta),
      child: child,
    );
  }
}