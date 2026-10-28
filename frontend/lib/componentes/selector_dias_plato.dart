import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/dias_semana.dart';

// En el formulario del plato: marca los días en que se sirve
class SelectorDiasPlato extends StatelessWidget {
  final List<String> seleccionados;
  final ValueChanged<List<String>> onCambio;

  const SelectorDiasPlato({
    super.key,
    required this.seleccionados,
    required this.onCambio,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Días en que se sirve',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.earthBrown),
        ),
        Wrap(
          spacing: 8,
          children: [
            for (final dia in diasSemana)
              FilterChip(
                label: Text(nombresDias[dia]!),
                selected: seleccionados.contains(dia),
                showCheckmark: false,
                selectedColor: AppColors.redPrayerFlag,
                backgroundColor: Colors.white.withValues(alpha: 0.6),
                labelStyle: TextStyle(
                  color: seleccionados.contains(dia)
                      ? AppColors.goldSand
                      : AppColors.earthBrown,
                ),
                onSelected: (marcado) {
                  final nuevos = [...seleccionados];
                  if (marcado) {
                    nuevos.add(dia);
                  } else {
                    nuevos.remove(dia);
                  }
                  onCambio(nuevos);
                },
              ),
          ],
        ),
      ],
    );
  }
}