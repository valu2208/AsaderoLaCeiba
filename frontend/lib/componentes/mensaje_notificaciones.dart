import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

// Ícono + texto para cuando la lista está vacía o falló la carga
// (con botón opcional para reintentar)
class MensajeNotificaciones extends StatelessWidget {
  final IconData icono;
  final String mensaje;
  final String? textoBoton;
  final VoidCallback? onBoton;

  const MensajeNotificaciones({
    super.key,
    required this.icono,
    required this.mensaje,
    this.textoBoton,
    this.onBoton,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Icon(icono, size: 50, color: AppColors.earthBrown),
          const SizedBox(height: 12),
          Text(
            mensaje,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.earthBrown, fontSize: 15),
          ),
          if (onBoton != null) ...[
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onBoton, child: Text(textoBoton ?? '')),
          ],
        ],
      ),
    );
  }
}