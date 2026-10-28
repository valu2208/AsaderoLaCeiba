import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/imagen_adaptable.dart';

// Parte de arriba del detalle: fondo rojo curvo con el plato en círculo que sobresale
class CabeceraDetalle extends StatelessWidget {
  final String? imagen;
  final IconData? icono; // se muestra si el plato no tiene foto

  const CabeceraDetalle({super.key, this.imagen, this.icono});

  Widget _plato(double diametro) {
    return Container(
      width: diametro,
      height: diametro,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipOval(
        child: imagen == null
            ? Container(
                color: AppColors.earthBrown,
                child: Icon(
                  icono ?? Icons.restaurant,
                  size: diametro * 0.4,
                  color: AppColors.goldSand,
                ),
              )
            : ImagenAdaptable(ruta: imagen!, ancho: diametro, alto: diametro),
      ),
    );
  }

  Widget _botonVolver(BuildContext context) {
    return Material(
      color: AppColors.goldSand,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => Navigator.pop(context),
        child: const SizedBox(
          width: 40,
          height: 40,
          child: Icon(Icons.arrow_back, color: AppColors.demonicPresence),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final medidas = MediaQuery.of(context);
    final ancho = medidas.size.width;
    final diametro = ancho * 0.74; // tamaño del plato
    final arriba = medidas.padding.top + 60; // espacio para la flecha de volver
    final altoFondo = arriba + diametro * 0.85; // el plato sobresale un poco

    return SizedBox(
      height: arriba + diametro + 16,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: altoFondo,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.demonicPresence,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(ancho / 2),
                ),
              ),
            ),
          ),
          Positioned(
            top: arriba,
            left: (ancho - diametro) / 2,
            child: _plato(diametro),
          ),
          Positioned(
            top: medidas.padding.top + 8,
            left: 12,
            child: _botonVolver(context),
          ),
        ],
      ),
    );
  }
}