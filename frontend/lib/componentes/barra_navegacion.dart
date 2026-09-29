
import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/fondo_barranavegacion.dart';

class BarraNavegacion extends StatelessWidget {
  final int indiceActual;
  final ValueChanged<int>? onTap;

  const BarraNavegacion({
    super.key,
    this.indiceActual = 0,
    this.onTap,
  });

  static const List<IconData> _iconos = [
    Icons.home_outlined,
    Icons.person_outline,
    Icons.menu,
    Icons.replay,
    Icons.sms_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.asphalt,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final ancho = constraints.maxWidth / _iconos.length;

              return CustomPaint(
                painter: FondoBarra(centro: ancho * (indiceActual + 0.5)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(_iconos.length, _item),
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
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: AppColors.asphalt,
        shape: BoxShape.circle,
      ),
    );
  }
}