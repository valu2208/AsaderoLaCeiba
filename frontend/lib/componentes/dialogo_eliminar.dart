import 'package:flutter/material.dart';

// Diálogo de confirmación antes de borrar un producto; devuelve true si el admin confirma
Future<bool> confirmarEliminacion(BuildContext context, {String? nombre}) async {
  final resultado = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Eliminar Producto'),
      content: Text(
        nombre == null
            ? '¿Estás seguro de que deseas eliminar este plato del menú?'
            : '¿Eliminar "$nombre" del menú? Esta acción no se puede deshacer.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
  return resultado == true;
}