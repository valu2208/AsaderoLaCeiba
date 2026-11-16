import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/componentes/cabecera_detalle.dart';
import 'package:asadero/componentes/seccion_detalles.dart';

// Detalle del plato: foto en círculo sobre fondo curvo, nombre, precio y descripción.
class DetalleProducto extends StatelessWidget {
  final String nombre;
  final String precio;
  final String? imagen;
  final String? descripcion;
  final IconData? icono;

  const DetalleProducto({
    super.key,
    required this.nombre,
    required this.precio,
    this.imagen,
    this.descripcion,
    this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Idioma.seleccionado,
      builder: (context, idioma, child) {
        final descripcionFinal = (descripcion ?? '').trim().isEmpty
            ? texto('descripcion_plato_generica')
            : descripcion!;

        return Scaffold(
          backgroundColor: AppColors.goldSand,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CabeceraDetalle(imagen: imagen, icono: icono),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              nombre,
                              style: GoogleFonts.josefinSans(
                                color: AppColors.asphalt,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            precio,
                            style: GoogleFonts.josefinSans(
                              color: AppColors.redPrayerFlag,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SeccionDetalles(texto: descripcionFinal),
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 32,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
