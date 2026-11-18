import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:asadero/componentes/visor_imagen.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';

// Botón para elegir la foto del comprobante y vista previa (se puede ampliar).
class SelectorComprobante extends StatelessWidget {
  final XFile? comprobante;
  final bool deshabilitado;
  final VoidCallback onElegir;

  const SelectorComprobante({
    super.key,
    required this.comprobante,
    required this.onElegir,
    this.deshabilitado = false,
  });

  Widget _vistaPrevia(BuildContext context) {
    final archivo = File(comprobante!.path);

    return GestureDetector(
      onTap: () => verImagenGrande(
        context,
        Image.file(
          archivo,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              archivo,
              height: 180,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          const Positioned(
            right: 6,
            bottom: 6,
            child: Icon(Icons.zoom_in, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          texto('instruccion_comprobante'),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: deshabilitado ? null : onElegir,
          icon: const Icon(Icons.image, color: AppColors.goldSand),
          label: Text(
            comprobante == null
                ? texto('seleccionar_comprobante')
                : texto('cambiar_comprobante'),
            style: const TextStyle(color: AppColors.goldSand),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.goldSand),
          ),
        ),
        if (comprobante != null) ...[
          const SizedBox(height: 12),
          _vistaPrevia(context),
        ],
      ],
    );
  }
}