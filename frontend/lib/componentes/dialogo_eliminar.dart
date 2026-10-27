import 'package:flutter/material.dart';

Future<bool> confirmarEliminacion(
  BuildContext context, {
  String? nombre,
}) async {
  final resultado = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Desactivar producto'),
      content: Text(
        nombre == null
            ? '¿Deseas desactivar este producto? No aparecerá en el menú, pero podrás reactivarlo después.'
            : '¿Deseas desactivar "$nombre"? No aparecerá en el menú, pero podrás reactivarlo después.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text(
            'Desactivar',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );

  return resultado == true;
}

// Borrar para siempre (falla si el producto ya tiene pedidos)
Future<bool> confirmarEliminacionDefinitiva(
  BuildContext context,
  String nombre,
) async {
  final resultado = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Eliminar definitivamente'),
      content: Text(
        '¿Eliminar "$nombre" permanentemente? '
        'Si tiene pedidos asociados, no podrá borrarse.',
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