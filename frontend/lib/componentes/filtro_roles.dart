import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/roles.dart';

// Fila de botones para filtrar la lista de usuarios por rol (null = todos)
class FiltroRoles extends StatelessWidget {
  final String? seleccionado;
  final ValueChanged<String?> onCambio;

  const FiltroRoles({
    super.key,
    required this.seleccionado,
    required this.onCambio,
  });

  Widget _opcion(String titulo, String? valor) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(titulo),
        selected: seleccionado == valor,
        selectedColor: AppColors.redPrayerFlag,
        backgroundColor: AppColors.goldSand,
        checkmarkColor: AppColors.goldSand,
        labelStyle: TextStyle(
          color: seleccionado == valor ? AppColors.goldSand : AppColors.earthBrown,
        ),
        onSelected: (_) => onCambio(valor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          _opcion('Todos', null),
          for (final rol in rolesSistema) _opcion(nombreRol(rol), rol),
        ],
      ),
    );
  }
}
