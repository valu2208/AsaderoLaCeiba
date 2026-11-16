import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

// Foto del plato en círculo con borde crema (como el borde de un plato) y sombra.
// Ocupa todo el espacio que le den, así sirve en la card y en la barra de arriba.
class FotoCircular extends StatelessWidget {
  final String imagen; // ruta en assets/imagenes/
  final IconData icono; // se muestra si la foto no existe

  const FotoCircular({super.key, required this.imagen, required this.icono});

  @override
  Widget build(BuildContext context) {
    final respaldo = Container(
      color: AppColors.earthBrown,
      alignment: Alignment.center,
      child: Icon(icono, size: 40, color: AppColors.goldSand),
    );

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.goldSand,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(-2, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          imagen,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) => respaldo,
        ),
      ),
    );
  }
}