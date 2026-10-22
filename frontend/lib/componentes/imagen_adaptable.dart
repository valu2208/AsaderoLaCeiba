import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

// Muestra una imagen que puede ser una URL (Cloudinary), un asset del proyecto
// o estar vacía (producto sin foto). Si falla, deja un ícono en su lugar.
class ImagenAdaptable extends StatelessWidget {
  final String ruta;
  final double? ancho;
  final double? alto;

  const ImagenAdaptable({
    super.key,
    required this.ruta,
    this.ancho,
    this.alto,
  });

  Widget _reemplazo({bool cargando = false}) {
    return Container(
      width: ancho,
      height: alto,
      color: AppColors.earthBrown,
      alignment: Alignment.center,
      child: cargando
          ? const CircularProgressIndicator(color: AppColors.goldSand)
          : const Icon(Icons.restaurant, color: AppColors.goldSand, size: 40),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (ruta.isEmpty) return _reemplazo();

    if (ruta.startsWith('http')) {
      return Image.network(
        ruta,
        width: ancho,
        height: alto,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progreso) =>
            progreso == null ? child : _reemplazo(cargando: true),
        errorBuilder: (context, error, stack) => _reemplazo(),
      );
    }

    return Image.asset(
      ruta,
      width: ancho,
      height: alto,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) => _reemplazo(),
    );
  }
}
