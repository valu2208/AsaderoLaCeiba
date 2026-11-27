import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/modo_admin.dart';

// Botón del encabezado del Inicio, solo para el admin que está viendo la carta
// del cliente: lo devuelve directo al panel de administración
class BotonVolverPanel extends StatelessWidget {
  const BotonVolverPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: AppColors.earthBrown,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            ModoAdmin.viendoCliente.value = false;
            Navigator.of(context).popUntil((ruta) => ruta.isFirst);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_back, size: 18, color: AppColors.goldSand),
                const SizedBox(width: 6),
                Text(
                  'Volver al panel',
                  style: GoogleFonts.kronaOne(
                    color: AppColors.goldSand,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}