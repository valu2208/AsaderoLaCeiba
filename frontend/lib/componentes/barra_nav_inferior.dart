import 'package:flutter/material.dart';
import 'package:asadero/componentes/fondo_barranavegacion.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/carrito_estado.dart';

class BarraNavegacionInferior extends StatelessWidget {
  final int indiceActual;
  final ValueChanged<int>? onTap;

  const BarraNavegacionInferior({super.key, this.indiceActual = 0, this.onTap});

  static const double _margen = 24;

  static const List<IconData> _iconos = [
    Icons.home_outlined,
    Icons.person_outline,
    Icons.grid_view,
    Icons.history,
    Icons.shopping_cart_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.asphalt,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final util = constraints.maxWidth - _margen * 2;
              final ancho = util / _iconos.length;

              return CustomPaint(
                painter: FondoBarra(
                  centro: _margen + ancho * (indiceActual + 0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: _margen),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(_iconos.length, _item),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _item(int indice) {
    final activo = indice == indiceActual;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap?.call(indice),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            if (activo) _circuloActivo(),
            if (indice == 4)
              ValueListenableBuilder(
                valueListenable: CarritoEstado.items,
                builder: (context, items, child) {
                  return _iconoCarrito();
                },
              )
            else
              Icon(_iconos[indice], size: 26, color: AppColors.goldSand),
          ],
        ),
      ),
    );
  }

  Widget _iconoCarrito() {
    final total = CarritoEstado.total;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(
          Icons.shopping_cart_outlined,
          size: 26,
          color: AppColors.goldSand,
        ),
        if (total > 0)
          Positioned(
            right: -10,
            top: -8,
            child: Container(
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              decoration: const BoxDecoration(
                color: AppColors.redPrayerFlag,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$total',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.goldSand,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _circuloActivo() {
    return Container(
      width: FondoBarra.radio * 2,
      height: FondoBarra.radio * 2,
      decoration: const BoxDecoration(
        color: AppColors.asphalt,
        shape: BoxShape.circle,
      ),
    );
  }
}
