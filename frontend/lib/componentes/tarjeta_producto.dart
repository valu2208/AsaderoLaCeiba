import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/carrito_estado.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/componentes/imagen_producto.dart';
import 'package:asadero/componentes/boton_agregar.dart';
import 'package:google_fonts/google_fonts.dart';

class TarjetaProducto extends StatelessWidget {
  final String productoId;
  final String nombre;
  final String nombreOriginal;
  final String precio;
  final String imagen;
  final String? nombreEn;
  final String? nombrePt;
  final VoidCallback onInformacion;

  const TarjetaProducto({
    super.key,
    required this.productoId,
    required this.nombre,
    required this.nombreOriginal,
    required this.precio,
    required this.imagen,
    this.nombreEn,
    this.nombrePt,
    required this.onInformacion,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Idioma.seleccionado,
      builder: (context, idioma, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final ancho = constraints.maxWidth;
            final altoImagen = ancho * 0.6;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 34),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.demonicPresence,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(12, altoImagen - 22, 12, 8),
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
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        precio,
                        style: GoogleFonts.josefinSans(
                          color: AppColors.goldSand,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: onInformacion,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft,
                              ),
                              child: Text(
                                texto('mas_informacion'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.josefinSans(
                                  color: AppColors.goldSand,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          ValueListenableBuilder<List<CarritoItem>>(
                            valueListenable: CarritoEstado.items,
                            builder: (context, items, child) {
                              return BotonAgregar(
                                cantidad: CarritoEstado.cantidadDe(
                                  nombreOriginal,
                                ),
                                onAgregar: () {
                                  CarritoEstado.agregar(
                                    productoId,
                                    nombreOriginal,
                                    precio,
                                    imagen,
                                    nombreEn: nombreEn,
                                    nombrePt: nombrePt,
                                  );
                                },
                                onRestar: () {
                                  CarritoEstado.restar(nombreOriginal);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: ancho * 0.13,
                  right: ancho * 0.13,
                  child: ImagenProducto(imagen: imagen, alto: altoImagen),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
