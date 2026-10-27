import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

// Fila de botones para elegir una opción (como el filtro de usuarios y roles).
// opciones: {valor que se guarda: texto que se muestra}
class FiltroChips extends StatelessWidget {
  final Map<String, String> opciones;
  final String seleccionado;
  final ValueChanged<String> onCambio;

  const FiltroChips({
    super.key,
    required this.opciones,
    required this.seleccionado,
    required this.onCambio,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          for (final opcion in opciones.entries)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(opcion.value),
                selected: seleccionado == opcion.key,
                showCheckmark: false,
                selectedColor: AppColors.redPrayerFlag,
                backgroundColor: AppColors.goldSand,
                labelStyle: TextStyle(
                  color: seleccionado == opcion.key
                      ? AppColors.goldSand
                      : AppColors.earthBrown,
                ),
                onSelected: (_) => onCambio(opcion.key),
              ),
            ),
        ],
      ),
    );
  }
}