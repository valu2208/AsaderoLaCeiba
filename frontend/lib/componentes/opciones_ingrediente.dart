import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

Widget _opcion(BuildContext context, IconData icono, String texto, String valor) {
  return ListTile(
    leading: Icon(icono, color: AppColors.goldSand),
    title: Text(texto, style: const TextStyle(color: AppColors.goldSand)),
    onTap: () => Navigator.pop(context, valor),
  );
}

// Menú inferior del ingrediente. Devuelve 'stock', 'editar', 'eliminar' o null.
Future<String?> elegirOpcionIngrediente(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: AppColors.asphalt,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _opcion(context, Icons.inventory_2_outlined, 'Ajustar cantidad', 'stock'),
          _opcion(context, Icons.edit_outlined, 'Editar', 'editar'),
          _opcion(context, Icons.delete_outline, 'Eliminar', 'eliminar'),
        ],
      ),
    ),
  );
}

// Pregunta si de verdad se quiere eliminar. Devuelve true solo si confirma.
Future<bool> confirmarEliminarIngrediente(BuildContext context, String nombre) async {
  final confirmado = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.asphalt,
      title: const Text('Eliminar ingrediente',
          style: TextStyle(color: AppColors.goldSand)),
      content: Text('¿Eliminar $nombre del inventario?',
          style: const TextStyle(color: AppColors.goldSand)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar', style: TextStyle(color: AppColors.goldSand)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Eliminar', style: TextStyle(color: AppColors.redPrayerFlag)),
        ),
      ],
    ),
  );
  return confirmado == true;
}