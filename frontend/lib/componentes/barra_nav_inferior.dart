import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/carrito_estado.dart';
import 'package:asadero/componentes/fondo_barranavegacion.dart';

class BarraNavegacionInferior extends StatelessWidget {
  final int indiceActual;
  final ValueChanged<int>? onTap;

  const BarraNavegacionInferior({super.key, this.indiceActual = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    final iconos = [
      Icons.home_outlined,
      Icons.person_outline,
      Icons.grid_view,
      Icons.history,
      Icons.shopping_cart_outlined,
    ];

    return SizedBox(
      height: 75,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final separacion = constraints.maxWidth / iconos.length;
          final centro = separacion * indiceActual + separacion / 2;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(painter: FondoBarra(centro: centro)),
              ),
              Row(
                children: List.generate(iconos.length, (indice) {
                  final seleccionado = indice == indiceActual;

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTap?.call(indice),
                      child: SizedBox(
                        height: 75,
                        child: Align(
                          alignment: Alignment(0, seleccionado ? -0.10 : 0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: seleccionado
                                  ? AppColors.asphalt
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: indice == 4
                                ? ValueListenableBuilder<List<CarritoItem>>(
                                    valueListenable: CarritoEstado.items,
                                    builder: (context, items, child) {
                                      final cantidad = CarritoEstado.total;

                                      return Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Icon(
                                            iconos[indice],
                                            size: 27,
                                            color: seleccionado
                                                ? AppColors.goldSand
                                                : Colors.white,
                                          ),
                                          if (cantidad > 0)
                                            Positioned(
                                              right: -9,
                                              top: -7,
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  3,
                                                ),
                                                constraints:
                                                    const BoxConstraints(
                                                      minWidth: 18,
                                                      minHeight: 18,
                                                    ),
                                                decoration: const BoxDecoration(
                                                  color:
                                                      AppColors.redPrayerFlag,
                                                  shape: BoxShape.circle,
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  cantidad > 99
                                                      ? '99+'
                                                      : '$cantidad',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  )
                                : Icon(
                                    iconos[indice],
                                    size: 27,
                                    color: seleccionado
                                        ? AppColors.goldSand
                                        : Colors.white,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
