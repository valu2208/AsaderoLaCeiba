import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/avisar_limite.dart';
import 'package:asadero/core/carrito_estado.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/componentes/boton_agregar.dart';
import 'package:asadero/componentes/imagen_adaptable.dart';
import 'package:asadero/componentes/visor_imagen.dart';

// Un plato en fila (como la lista del carrito): foto a la izquierda, nombre,
// descripción, precio y los botones − 1 +. Al tocar la fila se abre el detalle.
class FilaProducto extends StatelessWidget {
  final String productoId;
  final String nombre;
  final String precio;
  final String imagen;
  final String descripcion;
  final VoidCallback onInformacion;

  const FilaProducto({
    super.key,
    required this.productoId,
    required this.nombre,
    required this.precio,
    required this.imagen,
    required this.descripcion,
    required this.onInformacion,
  });

  Widget _foto() {
    return Container(
      width: 96,
      height: 96,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.goldSand,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: FotoAmpliable(
          ruta: imagen,
          child: ImagenAdaptable(ruta: imagen),
        ),
      ),
    );
  }

  Widget _botones() {
    return ValueListenableBuilder<List<CarritoItem>>(
      valueListenable: CarritoEstado.items,
      builder: (context, items, hijo) {
        return BotonAgregar(
          cantidad: CarritoEstado.cantidadDe(nombre),
          onAgregar: () => avisarLimite(
            context,
            CarritoEstado.agregar(productoId, nombre, precio, imagen),
          ),
          onRestar: () => CarritoEstado.restar(nombre),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.demonicPresence,
      elevation: 5,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onInformacion,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _foto(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombre,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.josefinSans(
                        color: AppColors.goldSand,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      descripcion.trim().isEmpty
                          ? texto('toca_ver_mas')
                          : descripcion,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.josefinSans(
                        color: AppColors.goldSand.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            precio,
                            style: GoogleFonts.josefinSans(
                              color: AppColors.goldSand,
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          ),
                        ),
                        _botones(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
