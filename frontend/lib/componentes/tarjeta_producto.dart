import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/carrito_estado.dart';
import 'package:asadero/componentes/imagen_producto.dart';
import 'package:asadero/componentes/boton_agregar.dart';
import 'package:google_fonts/google_fonts.dart';

class TarjetaProducto extends StatelessWidget {
  final String nombre;
  final String precio;
  final String imagen;
  final VoidCallback onInformacion;

  const TarjetaProducto({
    super.key,
    required this.nombre,
    required this.precio,
    required this.imagen,
    required this.onInformacion,
  });

  double _altoImagen(double ancho) => ancho * 0.6;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final ancho = constraints.maxWidth;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            _cuerpo(ancho),
            Positioned(
              top: 0,
              left: ancho * 0.13,
              right: ancho * 0.13,
              child: ImagenProducto(imagen: imagen, alto: _altoImagen(ancho)),
            ),
          ],
        );
      },
    );
  }

  Widget _cuerpo(double ancho) {
    return Container(
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
      padding: EdgeInsets.fromLTRB(12, _altoImagen(ancho) - 22, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nombre,
            maxLines: 2,
            style: GoogleFonts.josefinSans(
              color: AppColors.goldSand,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const Spacer(),
          _filaAcciones(),
        ],
      ),
    );
  }

  Widget _filaAcciones() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextButton(
            onPressed: onInformacion,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 30),
              alignment: Alignment.centerLeft,
            ),
            child: Text(
              'Más información',
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
              cantidad: CarritoEstado.cantidadDe(nombre),
              onAgregar: () {
                CarritoEstado.agregar(nombre, precio, imagen);
              },
              onRestar: () {
                CarritoEstado.restar(nombre);
              },
            );
          },
        ),
      ],
    );
  }
}
