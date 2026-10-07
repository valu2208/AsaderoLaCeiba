import 'package:flutter/material.dart';
import 'package:asadero/componentes/fondo_barranavegacion.dart';
import 'package:asadero/core/colores.dart';

class BarraNavegacionInferior extends StatelessWidget {
  final int indiceActual;
  final ValueChanged<int>? onTap;

  const BarraNavegacionInferior({
    super.key,
    this.indiceActual = 0,
    this.onTap,
  });

  static const double _margen = 24;

  static const List<IconData> _iconos = [
    Icons.home_outlined,
    Icons.person_outline,
    Icons.grid_view,
    Icons.history,
    Icons.sms_outlined,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: _margen,
                  ),
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
          children: [
            if (activo) _circuloActivo(),
            Icon(
              _iconos[indice],
              size: 26,
              color: AppColors.goldSand,
            ),
          ],
        ),
      ),
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